//
//  RandomSprite.h
//  DealShaker
//
//  Created by Jennifer Duffey on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseSprite.h"

@interface RandomSprite : BaseSprite 
{
	NSString *prefix;
	CCArray *spriteFrames;
	CCAnimation *blinkAnimation;
}

@property (nonatomic, retain) CCAnimation *blinkAnimation;
@property (nonatomic, retain) NSString *prefix;
@property (nonatomic, retain) CCArray *spriteFrames;

- (CCArray *)buildImageArrayFromPrefix:(NSString *)pre;
- (void)showRandomFrame;
- (CCAnimation *)buildBlinkAnimation;
- (void)showFrame:(int)frameIndex;

@end
