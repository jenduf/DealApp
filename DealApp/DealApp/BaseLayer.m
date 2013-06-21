//
//  BaseLayer.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseLayer.h"
#import "BaseSprite.h"
#import "SceneManager.h"

#define kAccelerationThreshold		0.5
#define kBreakThreshold				0.5

static BOOL AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) 
{
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

@implementation BaseLayer
@synthesize lastAcceleration;

- (id)init
{
	self = [super init];
	
	if (self) 
	{
		self.isAccelerometerEnabled = YES;
		stoppedShaking = NO;
		startedShaking = NO;
	}
	
	return self;
}

- (void)addButton
{
	// override
}

- (void)showIntroScene
{
	[[SceneManager sharedSceneManager] runSceneWithID:kIntroScene];
}

- (void)showBreakScene
{
	[emitter stopSystem];
	[[SceneManager sharedSceneManager] runSceneWithID:kBrokenScene];
}

- (void)shake
{
	// override
}

- (void)dealloc
{
	[lastAcceleration release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIAccelerometerMethods
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	static NSDate *lastDrawTime;
	
	double timePassed;
		
	BOOL didShake;
	
	if(self.lastAcceleration)
	{
		didShake = AccelerationIsShaking(lastAcceleration, acceleration, kAccelerationThreshold);
		
		if(didShake == YES)
		{
			lastStopTime = nil;
			startedShaking = YES;
			[self shake];
		}
		else
		{
			if(startedShaking == YES)
			{
				if(lastStopTime == nil)
					lastStopTime = [[NSDate alloc] init];
			}
				
		}
	}
	
	[lastDrawTime release];
	lastDrawTime = [[NSDate alloc] init];
	
	if(lastStopTime != nil)
		timePassed = [lastDrawTime timeIntervalSinceDate:lastStopTime];
	
	if(timePassed > kBreakThreshold)
	{
		[self showBreakScene];
	}
	
	self.lastAcceleration = acceleration;
	
}

@end
