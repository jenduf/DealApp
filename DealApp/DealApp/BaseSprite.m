//
//  BaseSprite.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseSprite.h"
#import "SceneManager.h"


@implementation BaseSprite
@synthesize shakeAnimation, shakeComplete;

- (id)initWithPrefix:(NSString *)pre andStartIndex:(int)start
{
	self = [super initWithFile:[NSString stringWithFormat:@"%@%i.png", pre, start]];
	
	if(self)
	{
		
		shakeComplete = YES;
		shakeAnimation = [[self buildAnimationFromPrefix:pre] retain];
	}
	
	return self;
}

- (CCAnimation *)buildAnimationFromPrefix:(NSString *)pre
{
	CCAnimation *animation = [CCAnimation animation];
	
	for(int i = 1; i < SPRITE_COUNT; i++)
	{
		NSString *animName = [NSString stringWithFormat:@"%@%i.png", pre, i];
		[animation addFrameWithFilename:animName];
	}
	
	return animation;
}

- (void)shakeWithTarget:(id)target times:(int)times
{
	if(shakeComplete == YES)
	{
		shakeComplete = NO;
		
		id shake = [CCAnimate actionWithDuration:0.5f animation:shakeAnimation restoreOriginalFrame:NO];
		//id repeatShake = [CCRepeat actionWithAction:[CCSequence actions:shake, [CCCallFunc actionWithTarget:self selector:@selector(playShakeSound)], nil] times:5];
		id repeatShake = [CCRepeat actionWithAction:shake times:times];
		
		id funcAction = nil;
		
		if(target != nil)
		{
			funcAction = [CCCallFuncND actionWithTarget:target selector:@selector(animationComplete:) data:self];
		}
		else
			shakeComplete = YES;
		
		[self runAction:[CCSequence actions:repeatShake, funcAction, nil]];
	}
}

- (void)dealloc
{
	[shakeAnimation release];
	
	[super dealloc];
}

@end
