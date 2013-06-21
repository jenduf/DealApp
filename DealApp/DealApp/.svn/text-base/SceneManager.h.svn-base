//
//  SceneManager.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SimpleAudioEngine.h"

@class Deal;
@interface SceneManager : NSObject
{
	SceneTypes currentScene;
	
	BOOL hasAudioBeenInitialized;
	SimpleAudioEngine *soundEngine;
	NSMutableDictionary *listOfSoundEffectFiles;
	
	SceneManagerSoundState managerSoundState;
}

@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (readwrite) SceneManagerSoundState managerSoundState;

+ (SceneManager *)sharedSceneManager; 
- (void)runSceneWithID:(SceneTypes)sceneID; 
- (void)setupAudioEngine;
- (void)loadAudio;
- (void)unloadAudio;
- (NSDictionary *)getSoundEffectsList;
- (ALuint)playSoundEffect:(NSString *)soundEffectKey;
- (void)stopSoundEffect:(ALuint)soundEffectID;
- (Deal *)getRandomDeal;

@end
