//
//  BackgroundView.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

-(id)initWithBackgroundImageName:(NSString *)imageName
{ 
	self = [super init];                                          
	
	if (self != nil) 
	{                                           
		backgroundImage = [CCSprite spriteWithFile:imageName];
		//brokenBackgroundImage = [[CCSprite spriteWithFile:@"broken_pig.jpg"] retain];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		[backgroundImage setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
		
		[self addChild:backgroundImage z:0 tag:0];
		//[self addChild:brokenBackgroundImage z:0 tag:0];
		
	}
	
	return self;                                               
}

- (void)switchBackground:(BOOL)isBroken
{
	if(isBroken == YES)
	{
		[self reorderChild:backgroundImage z:0];
		[self reorderChild:brokenBackgroundImage z:1];
	}
	else
	{
		[self reorderChild:backgroundImage z:1];
		[self reorderChild:brokenBackgroundImage z:0];
	}
}

@end
