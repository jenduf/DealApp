//
//  IntroLayer.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntroLayer.h"
#import "PimpIcon.h"
#import "DataArchiver.h"
#import "BaseSprite.h"
#import "Constants.h"
#import "SceneManager.h"
#import "RandomSprite.h"
#import "RestClient.h"

#define kUpdateAnimationThreshold				2.0
#define kUpdateSoundThreshold					.5

@implementation IntroLayer

+ (id)scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init
{
	self = [super init];
	
	if (self) 
	{
		accumulatedTime = 0;
		
		animationComplete = YES;
		buttonShaking = NO;
		
		[self addShadowSprite];
		[self addPigSprite];
		[self addTM];
		[self pimpPig];
		[self addButton];
		
		emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:PARTICLE_FILE];
		//emitter.autoRemoveOnFinish = YES;
		[emitter stopSystem];
		[self addChild:emitter z:1 tag:0];
		
		
		
		[self scheduleUpdate];
	}
	
	return self;
}

#pragma mark –
#pragma mark Update Method
-(void) update:(ccTime)deltaTime 
{
	accumulatedTime += deltaTime;
	
	if(startedShaking == NO)
	{
		if(accumulatedTime > kUpdateAnimationThreshold)
		{
			[tailSprite shakeWithTarget:nil times:1];
			[eyesSprite showRandomFrame];
			
			accumulatedTime = 0;
		}
	}
	else
	{
		if(accumulatedTime > kUpdateSoundThreshold)
		{
			if(stoppedShaking == NO || buttonShaking == YES)
			{
				[self playShakeSound];
			}
			
			accumulatedTime = 0;
		}
	}
}

- (void)addTM
{
	CCLabelTTF *tmLabel = [CCLabelTTF labelWithString:@"TM" fontName:@"Helvetica-Bold" fontSize:14.0];
	tmLabel.position = CGPointMake(LABEL_X, LABEL_Y);
	[self addChild:tmLabel z:2 tag:LABEL_TAG];
}

- (void)addButton
{
	CCMenuItemImage *shakeMenuItem = [CCMenuItemImage itemFromNormalImage:SHAKE_IT_BUTTON selectedImage:nil target:self selector:@selector(buttonShake)];
	shakeMenuItem.position = ccp(SHAKE_BUTTON_X, SHAKE_BUTTON_Y);
	CCMenu *shakeMenu = [CCMenu menuWithItems:shakeMenuItem, nil];
	shakeMenu.position = CGPointZero;
	[self addChild:shakeMenu z:2 tag:99];
}

- (void)addPigSprite
{
	pigSprite = [[BaseSprite alloc] initWithPrefix:PIG_PREFIX andStartIndex:0];
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	NSLog(@"Screen size - width: %f height: %f", screenSize.width, screenSize.height);
	[pigSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
	
	[self addChild:pigSprite z:1 tag:PIG_SPRITE];
	
	tailSprite = [[BaseSprite alloc] initWithPrefix:TAIL_PREFIX andStartIndex:1];
	[tailSprite setPosition:CGPointMake(TAIL_X, TAIL_Y)];
	[self addChild:tailSprite z:1];
	
	eyesSprite = [[RandomSprite alloc] initWithPrefix:EYE_PREFIX andStartIndex:1];
	[eyesSprite setPosition:CGPointMake(EYES_X, EYES_Y)];
	[self addChild:eyesSprite z:1];
}

- (void)addShadowSprite
{
	shadowSprite = [[BaseSprite alloc] initWithPrefix:SHADOW_PREFIX andStartIndex:1];
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	[shadowSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
	
	[self addChild:shadowSprite z:0 tag:SHADOW_SPRITE];
}

- (void)pimpPig
{
	NSDictionary *dict = (NSDictionary *)[DataArchiver retrieveData];
	
	NSEnumerator *enumerator = [dict keyEnumerator];
	id key;
	
	while ((key = [enumerator nextObject])) 
	{
		PimpIcon *pi = (PimpIcon *)[dict objectForKey:key];
		NSLog(@"Retrieving icon: %@", pi.imageName);
	}
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	PimpIcon *decalIcon = (PimpIcon *)[dict objectForKey:DECAL_ROW];
	
	if(decalIcon.imageName != nil)
	{
		NSString *decalName = [NSString stringWithFormat:@"%@%@", DECAL_PREFIX, decalIcon.imageName];
		decalSprite = [[BaseSprite alloc] initWithPrefix:decalName andStartIndex:1];
		[decalSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
		[self addChild:decalSprite z:1 tag:DECAL_SPRITE];
	}
	
	PimpIcon *glassesIcon = (PimpIcon *)[dict objectForKey:GLASSES_ROW];
	
	if(glassesIcon.imageName != nil)
	{
		NSString *glassesName = [NSString stringWithFormat:@"%@%@", GLASSES_PREFIX, glassesIcon.imageName];
		glassesSprite = [[BaseSprite alloc] initWithPrefix:glassesName andStartIndex:1];
		[glassesSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
		[self addChild:glassesSprite z:1 tag:GLASSES_SPRITE];
	}
	
	PimpIcon *hatsIcon = (PimpIcon *)[dict objectForKey:HAT_ROW];
	
	if(hatsIcon.imageName != nil)
	{
		NSString *hatName = [NSString stringWithFormat:@"%@%@", HAT_PREFIX, hatsIcon.imageName];
		hatSprite = [[BaseSprite alloc] initWithPrefix:hatName andStartIndex:1];
		[hatSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
		[self addChild:hatSprite z:1 tag:HAT_SPRITE];
	}
	
	PimpIcon *snoutIcon = (PimpIcon *)[dict objectForKey:MOUTH_ROW];
	
	if(snoutIcon.imageName != nil)
	{
		NSString *snoutName = [NSString stringWithFormat:@"%@%@", SNOUT_PREFIX, snoutIcon.imageName];
		snoutSprite = [[BaseSprite alloc] initWithPrefix:snoutName andStartIndex:1];
		[snoutSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
		[self addChild:snoutSprite z:1 tag:SNOUT_SPRITE];
	}
	
}

- (void)buttonShake
{
	[[SceneManager sharedSceneManager] playSoundEffect:SOUND_BUTTON_CLICK_KEY];
	buttonShaking = YES;
	startedShaking = YES;
	[self shake];
}

- (void)shake
{
	if([RestClient checkNetworkAvailable:YES] == YES)
	{
		CCMenu *menu = (CCMenu *)[self getChildByTag:99];
		[menu removeFromParentAndCleanup:NO];
		
		[self removeChild:eyesSprite cleanup:NO];
		[self removeChild:tailSprite cleanup:NO];
		
		animationComplete = NO;
		
		if(decalSprite != nil)
			[decalSprite shakeWithTarget:self times:SHAKE_COUNT];
		if(glassesSprite != nil)
			[glassesSprite shakeWithTarget:self times:SHAKE_COUNT];
		if(hatSprite != nil)
			[hatSprite shakeWithTarget:self times:SHAKE_COUNT];
		if(snoutSprite != nil)
			[snoutSprite shakeWithTarget:self times:SHAKE_COUNT];
		
		[shadowSprite shakeWithTarget:self times:SHAKE_COUNT];
		[pigSprite shakeWithTarget:self times:SHAKE_COUNT];

		[self playShakeSound];
		
		if(emitter.active == NO)
			[emitter resetSystem];
	}
	
}

- (void)playShakeSound
{
	int soundToPlay = random() % 3;
		
	NSLog(@"%i", soundToPlay);
		
	switch(soundToPlay)
	{
		case 0:
			[[SceneManager sharedSceneManager] playSoundEffect:SOUND_SHAKE_ONE_KEY];
			break;
		case 1:
			[[SceneManager sharedSceneManager] playSoundEffect:SOUND_SHAKE_TWO_KEY];
			break;
		case 2:
			[[SceneManager sharedSceneManager] playSoundEffect:SOUND_SHAKE_THREE_KEY];
			break;
	}
}

- (void)animationComplete:(BaseSprite *)sprite
{
	sprite.shakeComplete = YES;
	
	if(animationComplete == NO)
	{
		animationComplete = YES;
	
		[emitter stopSystem];
	
		if(stoppedShaking == YES || buttonShaking == YES)
		{
			[self showBreakScene];
		}
	}
	//[self verifyAnimationsComplete];
}

- (void)verifyAnimationsComplete
{
	CCArray *listOfGameObjects = [self children];
	
	for(id item in listOfGameObjects)
	{
		if([item isKindOfClass:[BaseSprite class]])
		{
			BaseSprite *sprite = (BaseSprite *)item;
			if(sprite.shakeComplete == NO)
				return;
		}
		else
			return;
	}
	
	animationComplete = YES;
	
     if(stoppedShaking == YES)
			[self showBreakScene];
}


@end
