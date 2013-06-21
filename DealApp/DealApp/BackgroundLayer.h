//
//  BackgroundView.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer 
{
	CCSprite *backgroundImage, *brokenBackgroundImage;
}

-(id)initWithBackgroundImageName:(NSString *)imageName;
- (void)switchBackground:(BOOL)isBroken;

@end
