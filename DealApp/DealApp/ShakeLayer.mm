//
//  PigView.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShakeLayer.h"
#import "BaseSprite.h"
#import "SceneManager.h"

@implementation ShakeLayer

+ (id)scene
{
	CCScene *scene = [CCScene node];
	ShakeLayer *layer = [ShakeLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init
{
    self = [super init];
	
    if (self) 
    {
	    isShaking = YES;
	    
	    [self shake];
    }
	
    return self;
}

- (void)shake
{
	animationComplete = NO;
	
	if(decalSprite != nil)
		[decalSprite shakeWithTarget:self];
	if(glassesSprite != nil)
		[glassesSprite shakeWithTarget:self];
	if(hatSprite != nil)
		[hatSprite shakeWithTarget:self];
	if(snoutSprite != nil)
		[snoutSprite shakeWithTarget:self];
	
	[shadowSprite shakeWithTarget:self];
	[pigSprite shakeWithTarget:self];
	
	emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:PARTICLE_FILE];
	emitter.autoRemoveOnFinish = YES;
	[self addChild:emitter z:1 tag:0];
}

- (void)animationComplete:(BaseSprite *)sprite
{
	animationComplete = YES;
	sprite.shakeComplete = YES;
}



@end
