//
//  PiggyBankLayer.h
//  PiggyBank
//
//  Created by Jennifer Duffey on 6/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


#import "CC3Layer.h"
#import "Joystick.h"
#import "PiggyBankWorld.h"

/** A sample application-specific CC3Layer subclass. */
@interface PiggyBankLayer : CC3Layer 
{
	Joystick *directionJoystick, *locationJoystick;
	
	UIAccelerationValue accel[3];
	
	CGFloat xVelocity, yVelocity;
	
	UIAcceleration *lastAcceleration;
}

@property (nonatomic, readonly) PiggyBankWorld *piggyBankWorld;
@property (nonatomic, retain) UIAcceleration *lastAcceleration;

-(void) addJoysticks;

@end
