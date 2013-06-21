//
//  BrokenScene.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrokenScene.h"
#import "Constants.h"
#import "BackgroundLayer.h"
#import "BrokenLayer.h"

@implementation BrokenScene

-(id)init 
{
	self = [super init];
	
	if (self != nil) 
	{
		// Background Layer
		backgroundLayer = [[BackgroundLayer alloc] initWithBackgroundImageName:BACKGROUND_IMAGE_BROKEN];//[BackgroundLayer node];
		[self addChild:backgroundLayer z:0];
		
		// Shake View
		brokenLayer = [BrokenLayer node];
		[self addChild:brokenLayer z:5]; 
	}
	
	return self;
}

@end
