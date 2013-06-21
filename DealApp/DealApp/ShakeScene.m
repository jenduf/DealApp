//
//  ShakeScene.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShakeScene.h"
#import "Constants.h"
#import "ShakeLayer.h"
#import "BackgroundLayer.h"

@implementation ShakeScene

-(id)init 
{
	self = [super init];
	
	if (self != nil) 
	{
		// Background Layer
		backgroundLayer = [[BackgroundLayer alloc] initWithBackgroundImageName:BACKGROUND_IMAGE_NORMAL]; // 1
		[self addChild:backgroundLayer z:0];                       // 2
		
		// Shake Layer
		shakeLayer = [ShakeLayer node];       // 3
		[self addChild:shakeLayer z:5];                         // 4
	}
	
	return self;
}

@end
