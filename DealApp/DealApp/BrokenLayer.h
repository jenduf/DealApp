//
//  BrokenLayer.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseLayer.h"

@class Deal;
@interface BrokenLayer : BaseLayer 
{
	CCMenu *dealMenu, *grabMenu;
	Deal *deal;
}

+ (id)scene;
- (void)createDealBanner;

@end
