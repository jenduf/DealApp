//
//  PiggyBankWorld.h
//  PiggyBank
//
//  Created by Jennifer Duffey on 6/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


#import "CC3World.h"
#import "CC3MeshNode.h"
#import "CC3PODResourceNode.h"
#import "CC3PODLight.h"

/**
 * Customized POD resource class to handle the idiosyncracies of how the POD file is
 * handled in the original PVRT demo app. This is not normally necessary. Normally,
 * the POD file should be created accurately to reflect the scene.
 */
@interface IntroducingPODResource : CC3PODResource {}
@end

/**
 * Customized light class to handle the idiosyncracies of how lights from the POD file
 * is handled in the original PVRT demo app. This is not normally necessary. Normally,
 * the POD file should be created accurately to reflect the scene.
 */
@interface IntroducingPODLight : CC3PODLight {}
@end

/** A sample application-specific CC3World subclass.*/
@interface PiggyBankWorld : CC3World 
{
	
	CGPoint playerDirectionalControl, playerLocationControl;
	
	UIAccelerationValue *accelerationValue;
	CGFloat xVelocity, yVelocity;
	float pigX, pigY, pigZ;
	
	IntroducingPODLight *podLight;
	
	// screen shake - duration and magnitude of jitter remaining
	float jitter; 
	
	// the current adjustment to camera location
	CC3Vector jitterCamera;
	
	// direction (rotation around z-axis) that the player is facing
	float pigDirection;
	
	// node for the pig itself
	CC3PODResourceNode *pigResource, *shatteredResource;
	
	// node for the main ground
	CC3MeshNode *mainGround;
	
	BOOL isShattering;
}

@property (nonatomic, assign) CGPoint playerDirectionalControl, playerLocationControl;

- (void)configureCamera;
- (void)updateCamera;
- (void)addPig;
- (void)dressPig:(NSDictionary *)dict forResource:(CC3PODResourceNode *)resource;
- (void)undressPig:(CC3PODResourceNode *)resource;
- (void)shatter;
- (void)addGround;
- (void)addAxisMarkers;
- (void)addJoystickLabels;
- (void)updateCameraFromControls: (ccTime) dt;
- (void)accelerometerUpdateforGravity:(UIAccelerationValue *)accelValue withVelocityX:(CGFloat)vx andVelocityY:(CGFloat)vy didShake:(BOOL)didShake;
- (void)updatePigLocation:(ccTime)dt;
- (void) updateScreenShake:(float) deltaTime;

@end
