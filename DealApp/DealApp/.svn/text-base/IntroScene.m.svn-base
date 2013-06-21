//
//  IntroScene.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntroScene.h"
#import "BackgroundLayer.h"
#import "IntroLayer.h"
#import "Constants.h"

@implementation IntroScene

-(id)init 
{
	self = [super init];
	
	if (self != nil) 
	{
		// Background Layer
		backgroundLayer = [[BackgroundLayer alloc] initWithBackgroundImageName:BACKGROUND_IMAGE_NORMAL];
		[self addChild:backgroundLayer z:0];
		
		// Intro Layer
		introLayer = [IntroLayer node]; 
		[self addChild:introLayer z:5];
	}
	
	return self;
}

@end
