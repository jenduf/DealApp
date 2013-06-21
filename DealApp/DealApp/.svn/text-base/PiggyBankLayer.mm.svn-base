//
//  PiggyBankLayer.m
//  PiggyBank
//
//  Created by Jennifer Duffey on 6/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "PiggyBankLayer.h"
#import "CC3Billboard.h"
#import "Constants.h"

#define kAccelerationThreshold		0.7

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

@implementation PiggyBankLayer
@synthesize lastAcceleration;

- (void)dealloc 
{
	[lastAcceleration release];
    [super dealloc];
}


/**
 * Template method that is invoked automatically during initialization, regardless
 * of the actual init* method that was invoked. Subclasses can override to set up their
 * 2D controls and other initial state without having to override all of the possible
 * superclass init methods.
 *
 * The default implementation does nothing. It is not necessary to invoke the
 * superclass implementation when overriding in a subclass.
 */

- (PiggyBankWorld *)piggyBankWorld
{
	return (PiggyBankWorld *)cc3World;
}

-(void) initializeControls 
{
	[self addJoysticks];
	
	xVelocity = 0;
	yVelocity = 0;
	
	self.isAccelerometerEnabled = YES;
}

- (void)addJoysticks
{
	CCSprite *jsThumb;
	
	// change thumb scale if you like smaller or larger controls
	GLfloat thumbScale = CC_CONTENT_SCALE_FACTOR();
	
	// the joystick that controls the player's (camera's) direction
	jsThumb = [CCSprite spriteWithFile:@"JoystickThumb.png"];
	jsThumb.scale = thumbScale;
	
	directionJoystick = [Joystick joystickWithThumb:jsThumb andSize:CGSizeMake(80, 80)];
	directionJoystick.position = ccp(8, 60);
	[self addChild:directionJoystick];
	
	jsThumb = [CCSprite spriteWithFile:@"JoystickThumb.png"];
	jsThumb.scale = thumbScale;
	
	locationJoystick = [Joystick joystickWithThumb:jsThumb andSize:CGSizeMake(80, 80)];
	locationJoystick.position = ccp(self.contentSize.width - 80 - 8, 60);
	[self addChild:locationJoystick];
}

/**
 * Positions the right-side location joystick at the right of the layer.
 * This is called at initialization, and anytime the content size of the layer changes
 * to keep the joystick in the correct location within the new layer dimensions.
 */
-(void) positionLocationJoystick {
	locationJoystick.position = ccp(self.contentSize.width - kJoystickSideLength - kJoystickPadding, kJoystickPadding);
}

/**
 * Called automatically when the contentSize has changed.
 * Move the location joystick to keep it in the bottom right corner of this layer
 * and the switch view button to keep it centered between the two joysticks.
 */
-(void) didUpdateContentSizeFrom: (CGSize) oldSize 
{
	[super didUpdateContentSizeFrom: oldSize];
	[self positionLocationJoystick];
}

 // The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 // The event dispatcher will not dispatch events for which there is no method
 // implementation. Since the touch-move events are both voluminous and seldom used,
 // the implementation of ccTouchMoved:withEvent: has been left out of the default
 // CC3Layer implementation. To receive and handle touch-move events for object
 // picking,uncomment the following method implementation. To receive touch events,
 // you must also set the isTouchEnabled property of this instance to YES.

 // Handles intermediate finger-moved touch events. 
/*-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event 
{
	BOOL itWorked = [self handleTouch: touch ofType: kCCTouchMoved];
}*/


#pragma mark Updating
- (void)update:(ccTime)dt
{
	// Update the player direction and position in the world from the joystick velocities
	self.piggyBankWorld.playerDirectionalControl = directionJoystick.velocity;
	self.piggyBankWorld.playerLocationControl = locationJoystick.velocity;
	[super update:dt];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	static NSDate *lastDrawTime;
	
	BOOL didShake;
	
	if(lastDrawTime != nil)
	{
		NSTimeInterval secondsSinceLastDraw = -([lastDrawTime timeIntervalSinceNow]);
		
		xVelocity = yVelocity + -(acceleration.y * secondsSinceLastDraw);
		yVelocity = xVelocity + acceleration.x * secondsSinceLastDraw;
		
		CGFloat xAcceleration = secondsSinceLastDraw * xVelocity * 500;
		CGFloat yAcceleration = secondsSinceLastDraw * yVelocity * 500;
		
		NSLog(@"X Velocity: %f, Y Velocity: %f, X Acceleration: %f, Y Acceleration: %f", xVelocity, yVelocity, xAcceleration, yAcceleration);
		
	}
	
	//float xValue = fabsf(acceleration.x);
	//float yValue = fabsf(acceleration.y);
	//float zValue = fabsf(acceleration.z);
	
	if(self.lastAcceleration)
	{
		didShake = AccelerationIsShaking(lastAcceleration, acceleration, kAccelerationThreshold);
	}
		
	
	accel[0] = acceleration.x * kFilterFactor + accel[0] * (1.0 - kFilterFactor);
	accel[1] = acceleration.y * kFilterFactor + accel[1] * (1.0 - kFilterFactor);
	accel[2] = acceleration.z * kFilterFactor + accel[2] * (1.0 - kFilterFactor);
	
	[self.piggyBankWorld accelerometerUpdateforGravity:accel withVelocityX:xVelocity andVelocityY:yVelocity didShake:didShake];
	
	[lastDrawTime release];
	lastDrawTime = [[NSDate alloc] init];
	
	self.lastAcceleration = acceleration;
	
}

@end
