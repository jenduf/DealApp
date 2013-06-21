//
//  IntroLayer.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseLayer.h"

@class BaseSprite, BaseLayer;
@interface IntroLayer : BaseLayer 
{
	CCSpriteBatchNode *sceneSpriteBatchNode;
	float accumulatedTime;
	BOOL buttonShaking;
}

+ (id)scene;
- (void)pimpPig;
- (void)addPigSprite;
- (void)addTM;
- (void)addShadowSprite;
- (void)verifyAnimationsComplete;
- (void)playShakeSound;

@end
