;//
//  SceneManager.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SceneManager.h"
#import "BrokenScene.h"
#import "IntroScene.h"
#import "RestClient.h"
#import "Deal.h"

@implementation SceneManager
@synthesize listOfSoundEffectFiles, managerSoundState;

static SceneManager *_sharedSceneManager = nil;

+(SceneManager *)sharedSceneManager 
{
	@synchronized([SceneManager class])                             // 2
	{
		if(!_sharedSceneManager)                                    // 3
			[[self alloc] init]; 
		return _sharedSceneManager;                                 // 4
	}
	
	return nil; 
}

+(id)alloc 
{
	@synchronized ([SceneManager class])                            // 5
	{
		NSAssert(_sharedSceneManager == nil,
			    @"Attempted to allocated a second instance of the Scene Manager singleton"); // 6
		_sharedSceneManager = [super alloc];
		return _sharedSceneManager;                                 // 7
	}
	return nil;  
}

-(id)init 
{                                                        // 8
	self = [super init];
	
	if(self)
	{
		hasAudioBeenInitialized = NO;
		soundEngine = nil;
		managerSoundState = kAudioManagerUninitialized;
		currentScene = kOpenScene;
	}
	
	return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID
{
	if(currentScene != sceneID || currentScene == kOpenScene)
	{
		SceneTypes oldScene = currentScene;
		currentScene = sceneID;
		
		id sceneToRun = nil;
		switch (sceneID)
		{
			case kOpenScene:
			case kIntroScene:
				sceneToRun = [IntroScene node];
				break;
			case kBrokenScene: 
				sceneToRun = [BrokenScene node];
				break;	
				
			default:
				CCLOG(@"Unknown ID, cannot switch scenes");
				return;
				break;
		}
		
		if(sceneToRun == nil)
		{
			// revert back since no new scene was found
			currentScene = oldScene;
			return;
		}
		
		// load audio for new scene
		[self performSelectorInBackground:@selector(loadAudio) withObject:nil];
		
		if ([[CCDirector sharedDirector] runningScene] == nil) 
		{
			[[CCDirector sharedDirector] runWithScene:sceneToRun];
			
		} 
		else 
		{
			// initialize a transition scene object
			CCTransitionFade *fadeTrans = [CCTransitionFade transitionWithDuration:0.4 scene:sceneToRun withColor:ccWHITE];
			[fadeTrans hideOutShowIn];
			[[CCDirector sharedDirector] replaceScene:fadeTrans];
		}
		
		[self performSelectorInBackground:@selector(unloadAudio) withObject:nil];
	}
}

- (void)setupAudioEngine
{
	if(hasAudioBeenInitialized == YES)
		return;
	
	hasAudioBeenInitialized = YES;
	
	NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
	NSInvocationOperation *asyncSetupOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(initAudioAsync) object:nil];
	[queue addOperation:asyncSetupOperation];
	[asyncSetupOperation autorelease];
}

- (void)initAudioAsync
{
	// initializes the audio engine asynchronously
	managerSoundState = kAudioManagerInitializing;
	
	// indicate that we are trying to start up the audio manager
	[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
	
	// Init audio manager asynchronously as it can take a few seconds
	// The FXPlusMusicIfNoOtherAudio mode will check if the user is
	// playing music and disable background music playback if
	// that is the case.
	[CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
	
	// wait for the audio manager to initialize
	while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
	{
		[NSThread sleepForTimeInterval:0.1];
	}
	
	// At this point the CocosDenshion should be initialized
	// Grab the cdaudiomanager and check the state
	CDAudioManager *audioManager = [CDAudioManager sharedManager];
	if(audioManager.soundEngine == nil || audioManager.soundEngine.functioning == NO)
	{
		CCLOG(@"CocosDenshion failed to init, no audio will play.");
		managerSoundState = kAudioManagerFailed;
	}
	else
	{
		[audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
		soundEngine = [SimpleAudioEngine sharedEngine];
		managerSoundState = kAudioManagerReady;
		CCLOG(@"CocosDenshion is Ready");
	}
	
}

- (void)loadAudio
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if(managerSoundState == kAudioManagerInitializing)
	{
		int waitCycles = 0;
		while(waitCycles < AUDIO_MAX_WAITTIME)
		{
			[NSThread sleepForTimeInterval:0.1f];
			if((managerSoundState == kAudioManagerReady) || (managerSoundState == kAudioManagerFailed))
			{
				break;
			}
			
			waitCycles = waitCycles + 1;
		}
	}
	
	if(managerSoundState == kAudioManagerFailed)
	{
		return;
	}
	
	listOfSoundEffectFiles = [[NSMutableDictionary alloc] initWithDictionary:[self getSoundEffectsList]];
	
	if(listOfSoundEffectFiles == nil)
	{
		CCLOG(@"Error loading SoundEffects");
		return;
	}
	
	for(NSString *keyString in listOfSoundEffectFiles)
	{
		CCLOG(@"\n Loading Audio Key:%@ File: %@", keyString, [listOfSoundEffectFiles objectForKey:keyString]);
		[soundEngine preloadEffect:[listOfSoundEffectFiles objectForKey:keyString]];
	}
	
	[pool release];
}

- (void)unloadAudio
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSDictionary *soundEffectsToUnload = [self getSoundEffectsList];
	
	if(soundEffectsToUnload == nil)
	{
		CCLOG(@"Error unloading SoundEffects");
		return;
	}
	
	if(managerSoundState == kAudioManagerReady)
	{
		// get all of the entries and unload
		for(NSString *keyString in soundEffectsToUnload)
		{
			CCLOG(@"\n Unloading Audio Key:%@ File: %@", keyString, [soundEffectsToUnload objectForKey:keyString]);
			[soundEngine unloadEffect:keyString];
		}

	}
	
		
	[pool release];
}

- (ALuint)playSoundEffect:(NSString *)soundEffectKey
{
	ALuint soundID = 0;
	
	if(managerSoundState == kAudioManagerReady)
	{
		soundID = [soundEngine playEffect:[listOfSoundEffectFiles objectForKey:soundEffectKey]];
	}
	else
	{
		CCLOG(@"GameMgr: Sound Manager is not ready, cannot play %@", soundEffectKey);
	}
	
	return soundID;
}

- (void)stopSoundEffect:(ALuint)soundEffectID
{
	if(managerSoundState == kAudioManagerReady)
	{
		[soundEngine stopEffect:soundEffectID];
	}
}
								 
- (NSDictionary *)getSoundEffectsList
{
	NSDictionary *soundEffectsToLoad = [NSDictionary dictionaryWithObjectsAndKeys:SOUND_BUTTON_CLICK,SOUND_BUTTON_CLICK_KEY,
								 SOUND_SHAKE_ONE,SOUND_SHAKE_ONE_KEY,SOUND_SHAKE_TWO,SOUND_SHAKE_TWO_KEY,SOUND_SHAKE_THREE,
								 SOUND_SHAKE_THREE_KEY,SOUND_SUCCESS,SOUND_SUCCESS_KEY,SOUND_BREAK,SOUND_BREAK_KEY,nil];
			
	return soundEffectsToLoad;
}

- (Deal *)getRandomDeal
{
	NSArray *deals = [NSArray arrayWithArray:[RestClient getDeals]];
	
	if(deals == nil || [deals count] == 0)
		return nil;
	
	int max = [deals count];
	int r = rand() % max;
	
	Deal *deal = (Deal *)[deals objectAtIndex:r];
	
	return deal;
}

- (void)dealloc
{
	[super dealloc];
}


@end
