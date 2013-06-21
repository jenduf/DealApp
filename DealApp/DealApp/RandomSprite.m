//
//  RandomSprite.m
//  DealShaker
//
//  Created by Jennifer Duffey on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RandomSprite.h"


@implementation RandomSprite
@synthesize prefix, spriteFrames, blinkAnimation;

- (id)initWithPrefix:(NSString *)pre andStartIndex:(int)start
{
	self = [super initWithFile:[NSString stringWithFormat:@"%@%i.png", pre, start]];
	
	if(self)
	{
		self.spriteFrames = [self buildImageArrayFromPrefix:pre];
		self.prefix = pre;
		self.blinkAnimation = [self buildBlinkAnimation];
	}
	
	return self;
}
					
- (CCArray *)buildImageArrayFromPrefix:(NSString *)pre
{
	CCArray *arr = [CCArray array];
	
	for(int i = 1; i < SPRITE_COUNT; i++)
	{
		NSString *imageName = [NSString stringWithFormat:@"%@%i.png", pre, i];
		CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:imageName];
		
		CGSize texSize = [texture contentSize];
		CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
		
		CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:texRect];
		[arr addObject:frame];
	}
			
	return arr;
}

- (CCAnimation *)buildBlinkAnimation
{
	CCAnimation *animation = [CCAnimation animation];
	
	for(int i = 1; i < SPRITE_COUNT; i+=4)
	{
		NSString *animName = [NSString stringWithFormat:@"%@%i.png", prefix, i];
		[animation addFrameWithFilename:animName];
	}
	
	return animation;
}

- (void)showFrame:(int)frameIndex
{
	[self setDisplayFrame:[self.spriteFrames objectAtIndex:frameIndex]];
}

- (void)showRandomFrame
{
	int randIndex = random() % (SPRITE_COUNT - 1);
	
	if(randIndex == 4)
	{
		id blink = [CCAnimate actionWithDuration:0.25f animation:blinkAnimation restoreOriginalFrame:YES];
		[self runAction:blink];
	}
	else
		[self setDisplayFrame:[self.spriteFrames objectAtIndex:randIndex]];
}

@end
