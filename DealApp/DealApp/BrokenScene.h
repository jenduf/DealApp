//
//  BrokenScene.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BackgroundLayer, BrokenLayer;
@interface BrokenScene : CCScene 
{
	BackgroundLayer *backgroundLayer;
	BrokenLayer *brokenLayer;
}

@end
