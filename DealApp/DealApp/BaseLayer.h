//
//  BaseLayer.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BaseSprite, RandomSprite;
@interface BaseLayer : CCLayer 
{
    	UIAcceleration *lastAcceleration;
	BOOL startedShaking, animationComplete, stoppedShaking;
	
	NSMutableArray *shakeResults;
	
	BaseSprite *snoutSprite, *glassesSprite, *decalSprite;
	BaseSprite *pigSprite, *shadowSprite, *hatSprite, *tailSprite;
	RandomSprite *eyesSprite;
	CCParticleSystem *emitter;
	
	NSDate *lastStopTime;
}

@property (nonatomic, retain) UIAcceleration *lastAcceleration;

- (void)addButton;
- (void)shake;
- (void)showIntroScene;
- (void)showBreakScene;

@end
