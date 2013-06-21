//
//  BaseSprite.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface BaseSprite : CCSprite 
{
	CCAnimation *shakeAnimation;
	BOOL shakeComplete;
}

@property (nonatomic, retain) CCAnimation *shakeAnimation;
@property (nonatomic, assign) BOOL shakeComplete;

- (id)initWithPrefix:(NSString *)pre andStartIndex:(int)start;
- (CCAnimation *)buildAnimationFromPrefix:(NSString *)pre;
- (void)shakeWithTarget:(id)target times:(int)times;

@end
