//
//  ShakeScene.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class BackgroundLayer, ShakeLayer;
@interface ShakeScene : CCScene 
{
	ShakeLayer *shakeLayer;
	BackgroundLayer *backgroundLayer;
}

@end
