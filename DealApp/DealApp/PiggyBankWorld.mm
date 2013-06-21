//
//  PiggyBankWorld.m
//  PiggyBank
//
//  Created by Jennifer Duffey on 6/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

extern "C" {
#import "CC3Foundation.h"  
};

#import "PiggyBankWorld.h"
#import "PimpIcon.h"
#import "CC3ActionInterval.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3Billboard.h"
#import "CCLabelTTF.h"
#import "CGPointExtension.h"
#import "Constants.h"
#import "CCTouchDispatcher.h"

float zAngle(float x, float y)
{
	float newDirection;
	newDirection = RadiansToDegrees(atan(y/x));
	if (y > 0.0 && x < 0.0)
	{
		newDirection = 180.0+newDirection;
	}
	else if (y < 0.0 && x < 0.0)
	{
		newDirection = 180.0+newDirection;
	}
	else if (y < 0.0 && x > 0.0)
	{
		newDirection = 360.0 + newDirection;
	}
	
	newDirection = newDirection-360.0;
	
	return newDirection;
}


@implementation PiggyBankWorld
@synthesize playerLocationControl, playerDirectionalControl;

-(void) dealloc {
	[super dealloc];
}

/**
 * Constructs the 3D world.
 *
 * Adds 3D objects to the world, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model world.
 *
 * NOTE: The POD file used for the 'hello, world' message model is fairly large,
 * because converting a font to a mesh results in a LOT of triangles. When adapting
 * this template project for your own application, REMOVE the POD file 'hello-world.pod'
 * from the Resources folder of your project!!
 */
-(void) initializeWorld 
{	
	pigX = 0.0;
	pigY = 0.0;
	pigZ = 0.0;
	
	isShattering = NO;
	
	// let there be light...
	//self.ambientLight = CCC4FMake(1.0f,1.0f,1.0f,0.2f);
	self.drawingSequencer = [CC3BTreeNodeSequencer sequencerLocalContentOpaqueFirstGroupMeshes];
	
	// This is the simplest way to load a POD resource file and add the
	// nodes to the CC3World, if no customized resource subclass is needed.
	//[self addContentFromPODResourceFile: @"Pig3.pod"];
	
	[self configureCamera];
	
	[self addPig];
	
	[self addAxisMarkers];
	
	[self addJoystickLabels];
	
	[self addGround];
	
	
	
	/*
	 
	 NSLog(@"Pig Data: Scale: %f, Location - x:%f y:%f z:%f, Rotation - x:%f y:%f z:%f", pigResourceNode.uniformScale, pigResourceNode.location.x, pigResourceNode.location.y, pigResourceNode.location.z, pigResourceNode.rotation.x, pigResourceNode.rotation.y, pigResourceNode.rotation.z);
	 */
	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
	
	// That's it! The model world is now constructed and is good to go.
	
	// ------------------------------------------
	
	//CC3MeshNode *pig = (CC3MeshNode *)[pigResourceNode getNodeNamed:@"Pig"];
	/*
	 // Box2D
	 // define the gravity sector
	 b2Vec2 gravity;
	 gravity.Set(0.0f, -1.0f);
	 
	 // do we want to let bodies sleep?
	 // this will speed up the physics simulation
	 // note * bodies seem to sleep when at rest for too long and will only wake up again on collision
	 bool doSleep = false;
	 
	 // construct a world object, which will hold and simulate the rigid bodies
	 _world = new b2World(gravity, doSleep);
	 _world->SetContinuousPhysics(false);
	 
	 b2BodyDef groundBodyDef;
	 groundBodyDef.position.Set(0,-100.0); // bottom left corner
	 
	 b2Body *groundBody = _world->CreateBody(&groundBodyDef);
	 
	 // define the ground box shape
	 b2PolygonShape groundBox;
	 
	 // bottom
	 groundBox.SetAsEdge(b2Vec2(0,-100.0), b2Vec2(screenSize.width/PTM_RATIO, 0));
	 groundBody->CreateFixture(&groundBox, 0);
	 
	 // top
	 groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO, screenSize.height/PTM_RATIO));
	 groundBody->CreateFixture(&groundBox, 0);
	 
	 // left
	 groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0, -100.0));
	 groundBody->CreateFixture(&groundBox, 0);
	 
	 // right
	 groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO, 0));
	 groundBody->CreateFixture(&groundBox, 0);
	 
	 // create pig
	 b2BodyDef pigBodyDef;
	 pigBodyDef.type = b2_dynamicBody;
	 pigBodyDef.position.Set(0, -60);
	 pigBodyDef.userData = pig;
	 b2Body *pigBody = _world->CreateBody(&pigBodyDef);
	 
	 b2CircleShape circle;
	 circle.m_radius = screenSize.width/5/PTM_RATIO;
	 
	 b2FixtureDef pigShapeDef;
	 pigShapeDef.shape = &circle;
	 pigShapeDef.density = 2.0f;
	 pigShapeDef.friction = 0.2f;
	 pigShapeDef.restitution = 0.35f;
	 pigShapeDef.isSensor = FALSE;
	 pigBody->CreateFixture(&pigShapeDef);*/
	
	//[self addChild:pigResourceNode];
	
}

- (void)configureCamera
{
	// Create the camera, place it back a bit, and add it to the world
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v(0.0, 0.0, ZOOM);
	cam.rotation = cc3v(0.0f, 0.0f, 0.0f);
	[self addChild: cam];
	
	self.activeCamera = cam;
	
	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the world
	CC3Light *lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( 4.0, 1.0, 5.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];
	
	CC3Light *lamp2 = [CC3Light nodeWithName: @"Lamp"];
	lamp2.location = cc3v( 0.0, 1.0, -5.0 );
	lamp2.isDirectionalOnly = NO;
	//[cam addChild: lamp2];*/
	
//	podLight = (IntroducingPODLight *)[self getNodeNamed:@"Lamp"];
	
	//self.ambientLight = kCC3DefaultLightColorAmbientWorld;
	
	//self.activeCamera.location = cc3v(-10.0, 10 , 90 );
	//self.activeCamera.rotation = cc3v( -30.0 , -10 , 0 );
	
	//self.activeCamera.uniformScale = 0.7;
	
	/*	NSLog(@"Active Camera Data: Scale: %f, Location - x:%f y:%f z:%f, Rotation - x:%f y:%f z:%f", self.activeCamera.uniformScale, self.activeCamera.location.x, self.activeCamera.location.y, self.activeCamera.location.z, self.activeCamera.rotation.x, self.activeCamera.rotation.y, self.activeCamera.rotation.z );*/
}

- (void)addPig
{
	pigResource = [[CC3PODResourceNode nodeWithName:@"Final_Pig"] retain];
	//pigResource.resource = [IntroducingPODResource resourceFromResourceFile:@"Pig_Complete_01b.pod"];
	pigResource.resource = [IntroducingPODResource resourceFromResourceFile:@"Pig_Clothed.pod"];
	pigResource.location = cc3v(0.0, -5.0, 0.0);
	pigResource.rotation = cc3v(5.0, -20.0, 0.0);
	
	/*
	pigResource.location = cc3v(0.0, 0.0, 0.0);
	pigResource.rotation = cc3v(10.0, -20.0, 0.0);
	[pigResource touchEnableAll];
	[self addChild:pigResource];*/
	
	//self.ambientLight = kCC3DefaultLightColorAmbientWorld;	
	 
	//CC3MeshNode *pigMesh = (CC3MeshNode *)[pigResource getNodeNamed:@"Final_Pig"];
	//pigMesh.location = cc3v(0.0, -5.0, 0.0);
	//pigMesh.rotation = cc3v(5.0, -20.0, 0.0);
	//pigMesh.material = [CC3Material shiny];
	// pigMesh.uniformScale = 50.0;
	// pigMesh.isTouchEnabled = YES;
	// [self addChild:pigMesh];
	
	[self undressPig:nil];
}

- (void)undressPig:(CC3PODResourceNode *)resource
{
	if(resource == nil)
	{
		resource = pigResource;

		[self addChild:pigResource];
		[self removeChild:shatteredResource];
		
		isShattering = NO;
	}
	
	CC3MeshNode *cowboyMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_COWBOY_HAT];
	[cowboyMesh setVisible:NO];
	
	CC3MeshNode *capMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_BASEBALL_CAP];
	[capMesh setVisible:NO];
	
	CC3MeshNode *fancyMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_FANCY_HAT];
	[fancyMesh setVisible:NO];
	
	CC3MeshNode *sunglassesMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_SUNGLASSES];
	[sunglassesMesh setVisible:NO];
	
	CC3MeshNode *monocleMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_MONOCLE];
	[monocleMesh setVisible:NO];
	
	CC3MeshNode *eyepatchMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_EYE_PATCH];
	[eyepatchMesh setVisible:NO];
	
	CC3MeshNode *beardMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_BEARD];
	[beardMesh setVisible:NO];
	
	CC3MeshNode *lipsMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_LIPS];
	[lipsMesh setVisible:NO];
	
	CC3MeshNode *moustacheMesh = (CC3MeshNode *)[resource getNodeNamed:PIMP_MOUSTACHE];
	[moustacheMesh setVisible:NO];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *dict = (NSDictionary *)[defaults objectForKey:@"Pig_Pimped"];
	
	if(dict != nil)
		[self dressPig:dict forResource:resource];
}
		 
- (void)dressPig:(NSDictionary *)dict forResource:(CC3PODResourceNode *)resource
{
	for(PimpIcon *pi in dict)
	{
		CC3MeshNode *meshNode = (CC3MeshNode *)[resource getNodeNamed:pi.imageName];
		[meshNode setVisible:YES];
	}
}

- (void)addGround
{
	CC3PlaneNode* ground = [CC3PlaneNode nodeWithName: @"Ground"];
	[ground populateAsCenteredRectangleWithSize: CGSizeMake(2000.0, 2000.0)
							  withTexture: [CC3Texture textureFromFile: @"background.jpg"]
							invertTexture: YES];
	ground.location = cc3v(0.0f, -50.0f, 0.0f);
	ground.rotation = cc3v(-90.0, 180.0, 0.0);
	ground.name = @"Ground";
	ground.shouldCullBackFaces = NO;	// Show the ground from below as well.
	ground.isTouchEnabled = YES;		// Allow the ground to be selected by touch events.
	[ground retainVertexLocations];	// Retain location data in main memory, even when it
	// is buffered to a GL VBO via releaseRedundantData,
	// so that it may be accessed for further calculations
	// when dropping objects on the ground.
	[self addChild: ground];
	mainGround = ground;
}

- (void)addAxisMarkers
{
	// But to add some dynamism, we'll animate the 'hello, world' message
	// using a couple of cocos2d actions...
	
	// Fetch the 'hello, world' 3D text object that was loaded from the
	// POD file and start it rotating
	
	//CC3PODResourceNode *helloNode = [CC3PODResourceNode nodeWithName:@"Hello"];
	//helloNode.resource = [CC3PODResource resourceFromResourceFile:@"hello-world.pod"];
	CCLabelTTF* bbLabel = [CCLabelTTF labelWithString: @"100 on X - Axis"
									 fontName: @"Marker Felt"
									 fontSize: 30.0];
	bbLabel.color = ccYELLOW;
	CC3Billboard* bb = [CC3Billboard nodeWithName: @"Billboard" withBillboard:bbLabel];
	bb.unityScaleDistance = 250.0;
	bb.location = cc3v( 100.0, 0, 0.0 );
	//bb.offsetPosition = ccp( 0.0, 15.0 );
	[self addChild:bb];
	
	CCLabelTTF* bbLabel2 = [CCLabelTTF labelWithString: @"100 on Y - Axis"
									  fontName: @"Marker Felt"
									  fontSize: 30.0];
	bbLabel2.color = ccRED;
	CC3Billboard* bb2 = [CC3Billboard nodeWithName: @"Billboard" withBillboard:bbLabel2];
	bb2.unityScaleDistance = 250.0;
	bb2.location = cc3v( 0, 100.0, 0.0 );
	[self addChild:bb2];
	
	CCLabelTTF* bbLabel3 = [CCLabelTTF labelWithString: @"100 on Z - Axis"
									  fontName: @"Marker Felt"
									  fontSize: 30.0];
	bbLabel3.color = ccBLUE;
	CC3Billboard* bb3 = [CC3Billboard nodeWithName: @"Billboard" withBillboard:bbLabel3];
	bb3.unityScaleDistance = 250.0;
	bb3.location = cc3v( 0, 0, 100.0 );
	[self addChild:bb3];
	
	//CC3MeshNode* helloTxt = (CC3MeshNode*)[helloNode getNodeNamed: @"Hello"];
	//CCActionInterval* partialRot = [CC3RotateBy actionWithDuration: 1.0
	//							    rotateBy: cc3v(0.0, 30.0, 0.0)];
	//[helloTxt runAction: [CCRepeatForever actionWithAction: partialRot]];
	
	// To make things a bit more appealing, set up a repeating up/down cycle to
	// change the color of the text from the original red to blue, and back again.
	//GLfloat tintTime = 8.0f;
	//ccColor3B startColor = helloTxt.color;
	//ccColor3B endColor = { 50, 0, 200 };
	//CCActionInterval* tintDown = [CCTintTo actionWithDuration: tintTime
	//    red: endColor.r
	//	  green: endColor.g
	//	   blue: endColor.b];
	//CCActionInterval* tintUp = [CCTintTo actionWithDuration: tintTime
	//	  red: startColor.r
	//	green: startColor.g
	//	 blue: startColor.b];
	//CCActionInterval* tintCycle = [CCSequence actionOne: tintDown two: tintUp];
	//[helloTxt runAction: [CCRepeatForever actionWithAction: tintCycle]];
	
	//helloNode.location = cc3v(100.0, 0.0, 0.0);
}

- (void)addJoystickLabels
{
	CCLabelTTF* bbLabel = [CCLabelTTF labelWithString: @"Direction"
									 fontName: @"Marker Felt"
									 fontSize: 50.0];
	bbLabel.color = ccWHITE;
	CC3Billboard* bb = [CC3Billboard nodeWithName: @"Billboard" withBillboard:bbLabel];
	bb.unityScaleDistance = 250.0;
	bb.location = cc3v( -248.0, -310.0, 10.0 );
	//bb.offsetPosition = ccp( 0.0, 15.0 );
	[self addChild:bb];
	
	CCLabelTTF* bbLabel2 = [CCLabelTTF labelWithString: @"Location"
									  fontName: @"Marker Felt"
									  fontSize: 50.0];
	bbLabel2.color = ccWHITE;
	CC3Billboard* bb2 = [CC3Billboard nodeWithName: @"Billboard" withBillboard:bbLabel2];
	bb2.unityScaleDistance = 250.0;
	bb2.location = cc3v( 248.0, -310.0, 10.0 );
	//bb.offsetPosition = ccp( 0.0, 15.0 );
	[self addChild:bb2];
}

- (void)shatter
{
	if(isShattering == NO)
	{
		isShattering = YES;
		
		if(shatteredResource == nil)
		{
			shatteredResource = [[CC3PODResourceNode nodeWithName:@"Final_Pig"] retain];
			shatteredResource.resource = [IntroducingPODResource resourceFromResourceFile:@"Fractured_Pig.pod"];
			shatteredResource.location = cc3v(0.0, -5.0, 0.0);
			shatteredResource.rotation = cc3v(5.0, -20.0, 0.0);
		}
		
		//[self addContentFromPODResourceFile:@"Fractured_Pig.pod"];
		[self enableAllAnimation];
		//[shatteredRes touchEnableAll];
		[self addChild:shatteredResource];
		[self removeChild:pigResource];
		
		[self undressPig:shatteredResource];
		
		CC3MeshNode *eyeMesh = (CC3MeshNode *)[shatteredResource getNodeNamed:@"Eyes"];
		[eyeMesh setVisible:NO];
		
		CC3MeshNode *tailMesh = (CC3MeshNode *)[shatteredResource getNodeNamed:@"Tail"];
		[tailMesh setVisible:NO];
		
		//CC3MeshNode *pigMesh = (CC3MeshNode *)[shatteredRes getNodeNamed:@"Pig"];
		
		CCActionInterval *shatterAction = [CC3Animate actionWithDuration:10.0];
		[shatteredResource runAction:[CCRepeat actionWithAction:shatterAction times:1]];
	}
}

- (void)accelerometerUpdateforGravity:(UIAccelerationValue *)accelValue withVelocityX:(CGFloat)vx andVelocityY:(CGFloat)vy didShake:(BOOL)didShake
{
	//NSLog(@"Gravity x:%f y:%f", gravX, gravY);
	accelerationValue = accelValue;
	
	xVelocity = vx;
	yVelocity = vy;
	
	if(didShake == YES)
		[self shatter];
}


/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides this node with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the node. The similar and complimentary
 * method updateAfterTransform: is automatically invoked after the transformMatrix has been
 * recalculated. If you need to make changes to the transform properties (location, rotation,
 * scale) of the node, or any child nodes, you should override this method to perform those
 * changes.
 *
 * The global transform properties of a node (globalLocation, globalRotation, globalScale)
 * will not have accurate values when this method is run, since they are only valid after
 * the transformMatrix has been updated. If you need to make use of the global properties
 * of a node (such as for collision detection), override the udpateAfterTransform: method
 * instead, and access those properties there.
 *
 * The specified visitor encapsulates the CC3World instance, to allow this node to interact
 * with other nodes in its world.
 *
 * The visitor also encapsulates the deltaTime, which is the interval, in seconds, since
 * the previous update. This value can be used to create realistic real-time motion that
 * is independent of specific frame or update rates. Depending on the setting of the
 * maxUpdateInterval property of the CC3World instance, the value of dt may be clamped to
 * an upper limit before being passed to this method. See the description of the CC3World
 * maxUpdateInterval property for more information about clamping the update interval.
 *
 * As described in the class documentation, in keeping with best practices, updating the
 * model state should be kept separate from frame rendering. Therefore, when overriding
 * this method in a subclass, do not perform any drawing or rending operations. This
 * method should perform model updates only.
 *
 * This method is invoked automatically at each scheduled update. Usually, the application
 * never needs to invoke this method directly.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor 
{
	
	/*if(gravityX > 0 || gravityY > 0)
	 {
	 
	 b2Vec2 gravity = b2Vec2(gravityX, gravityY);
	 
	 _world->SetGravity(gravity);
	 }*/
}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides this node with an opportunity to perform update activities after
 * the transformMatrix of the node has been recalculated. The similar and complimentary
 * method updateBeforeTransform: is automatically invoked before the transformMatrix
 * has been recalculated.
 *
 * The global transform properties of a node (globalLocation, globalRotation, globalScale)
 * will have accurate values when this method is run, since they are only valid after the
 * transformMatrix has been updated. If you need to make use of the global properties
 * of a node (such as for collision detection), override this method.
 *
 * Since the transformMatrix has already been updated when this method is invoked, if
 * you override this method and make any changes to the transform properties (location,
 * rotation, scale) of any node, you should invoke the updateTransformMatrices method of
 * that node, to have its transformMatrix, and those of its child nodes, recalculated.
 *
 * The specified visitor encapsulates the CC3World instance, to allow this node to interact
 * with other nodes in its world.
 *
 * The visitor also encapsulates the deltaTime, which is the interval, in seconds, since
 * the previous update. This value can be used to create realistic real-time motion that
 * is independent of specific frame or update rates. Depending on the setting of the
 * maxUpdateInterval property of the CC3World instance, the value of dt may be clamped to
 * an upper limit before being passed to this method. See the description of the CC3World
 * maxUpdateInterval property for more information about clamping the update interval.
 *
 * As described in the class documentation, in keeping with best practices, updating the
 * model state should be kept separate from frame rendering. Therefore, when overriding
 * this method in a subclass, do not perform any drawing or rending operations. This
 * method should perform model updates only.
 *
 * This method is invoked automatically at each scheduled update. Usually, the application
 * never needs to invoke this method directly.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor 
{
	if(accelerationValue != nil)
	{
		//[self updatePigLocation:visitor.deltaTime];
		//[self updateScreenShake:visitor.deltaTime];	
		//[self updateCamera];
	}
	
	[self updateCameraFromControls:visitor.deltaTime];
	
	//int32 velocityIterations = 1;
	//int32 positionIterations = 1;					 
	
	/*
	 // iterate over the bodies in the physics world
	 for(b2Body *b = _world->GetBodyList(); b; b = b->GetNext())
	 {
	 if(b->GetUserData() != NULL)
	 {
	 CGSize winSize = [CCDirector sharedDirector].winSize;
	 GLfloat aspect = winSize.width / winSize.height;
	 
	 // Express touch point x & y as fractions of the window size
	 GLfloat xtp = ((2.0 * b->GetPosition().x * PTM_RATIO) / winSize.width) - 1;
	 GLfloat ytp = ((2.0 * b->GetPosition().y * PTM_RATIO) / winSize.height) - 1;
	 
	 // get the tangent of half of the camera's field of view angle
	 GLfloat effectiveFOV = activeCamera.fieldOfView / self.uniformScale;
	 GLfloat halfFOV = effectiveFOV / 2.0;
	 GLfloat tanHalfFOV = tanf(DegreesToRadians(halfFOV));
	 
	 // get the distance from the camera to the projection plane
	 GLfloat zCam = activeCamera.globalLocation.z;
	 
	 // calc the x and y coordinates on the z = 0 plane using trig and similar triangles
	 CC3Vector tp3D = cc3v(tanHalfFOV * xtp * aspect * zCam, tanHalfFOV * ytp * zCam, 0.0f);
	 
	 // synchronize the mesh position with the corresponding body
	 CC3MeshNode *myActor = (CC3MeshNode *)b->GetUserData();
	 myActor.location = cc3v(tp3D.x, tp3D.y, 0);
	 }
	 }*/
	
}

- (void)updatePigLocation:(float)dt
{
	float newX = accelerationValue[0] * MOVE_MODIFIER;
	float newY = accelerationValue[1] * MOVE_MODIFIER;
	float newZ = accelerationValue[2] * MOVE_MODIFIER;
	
	// find the distance this would be
	float distance = MAX(sqrt(newX * newX + newY * newY) / sqrt(2), 0.0);
	
	// find the new direction the tilt is, along Z axis
	float newDirection = (distance > MOVEMENT_THRESHOLD) ? Cyclic(zAngle(newX, newY), 360.0) : pigDirection;
	
	// find the difference between the pig's current direction and find the actual rotational differences
	float rotation = CyclicDifference(newDirection, pigDirection, 360);
	rotation = rotation > MAX_ROTATE_SPEED * (dt * 30) ? MAX_ROTATE_SPEED * (dt * 30) : rotation;
	rotation = rotation < -MAX_ROTATE_SPEED * (dt * 30) ? -MAX_ROTATE_SPEED * (dt * 30) : rotation;
	
	pigDirection += rotation;
	
	// only move if it is tilted enough
	if(distance > MOVEMENT_THRESHOLD)
	{
		pigX += distance * cos(DegreesToRadians(pigDirection)) * (dt * 30) * xVelocity;
		pigY += distance * sin(DegreesToRadians(pigDirection)) * (dt * 30) * yVelocity;
		pigZ += distance * atan(DegreesToRadians(pigDirection)) * (dt * 30) * MOVEMENT_SPEED;
	}
	
	CC3MeshNode* pigTemplate = (CC3MeshNode *)[pigResource getNodeNamed: @"Pig"];
	
	pigTemplate.location = cc3v(pigX, pigY, 0);
	
	pigTemplate.rotation = cc3v(0, 0, pigDirection);
	
	//float accelerationX = gravityX * (dt * 30) * 1000;
	//float accelerationY = gravityY * (dt * 30) * 1000;
	//float accelerationZ = gravityZ * (dt * 30) * 1000;
	
	//velocityX = velocityX + gravityX * dt;
	//velocityY = velocityY + -(gravityY * dt);
	//velocityZ = velocityZ + gravityZ * dt;
	
	//float xAcceleration = dt * velocityX * 500;
	//float yAcceleration = dt * velocityY * 500;
	//float zAcceleration = dt * velocityZ * 500;
	
	//newLocation = CC3VectorAdd(pigTemplate.location, newLocation);
	//newRotation = CC3VectorRotationalDifference(pigTemplate.rotation, newRotation);
	
	//[pigTemplate runAction:[CC3MoveTo actionWithDuration:1.0 moveTo:newLocation]];
	//[pigTemplate runAction:[CCRepeatForever actionWithAction: [CC3RotateBy actionWithDuration: 1.0
	//			 rotateBy: cc3v(30.0, 0.0, 45.0)]]];//[CC3RotateTo actionWithDuration:dt rotateTo:newRotation]];
	//[pigTemplate setLocation:cc3v(pigX, pigY, pigZ)];
	//[pigTemplate setRotation:cc3v(0, 0, pigDirection)];
	
	
	//	NSLog(@"gravityX: %f gravityY: %f gravityZ: %f time: %f newX: %f newY: %f newZ: %f distance: %f newDirection: %f rotation: %f pigX: %f pigY: %f pigZ: %f", gravityX, gravityY, gravityZ, dt, newX, newY, newZ, distance, newDirection, rotation, pigX, pigY, pigZ);
	
	//previousTime = CACurrentMediaTime();
	/*
	 
	 float angle = atan2(yy, xx);
	 angle *= 180.0/3.14159;
	 
	 
	 
	 CGPoint delta = ccpMult(CGPointMake(pigResourceNode.location.x, pigResourceNode.location.y), dt * 30.0);
	 
	 CC3Vector controlVector = CC3VectorAdd(activeCamera.rightDirection, activeCamera.worldUpDirection);
	 
	 CC3Vector newLocation = cc3v(gravityX, gravityY, 0);
	 CC3Vector experimentalLocation = CC3VectorAdd(pigResourceNode.location, CC3VectorScale(controlVector, cc3v(delta.x, delta.y, delta.x)));
	 //CCActionInterval *animatePig = [CC3MoveTo actionWithDuration:deltaTime moveTo:newLocation];
	 //animatePig = [CCEaseInOut actionWithAction:animatePig rate:4.0f];
	 CC3PODResourceNode *pigResourceNode = [CC3PODResourceNode nodeWithName:@"Pig"];
	 [pigResourceNode runAction:[CC3MoveTo actionWithDuration:deltaTime moveTo:newLocation]];
	 
	 //NSLog(@"Pig description:%@", [pigNode fullDescription]);
	 
	 NSLog(@"previous time:%f delta time:%f gravityX:%f gravityY:%f", previousTime, deltaTime, gravityX, gravityY);
	 */
}

/*
 - (void)updateAcceleratedValue:(ccTime)dt
 {
 if(accelerationValue != nil)
 {
 GLfloat matrix[4][4], length;
 
 length = sqrtf(accelerationValue[0] * accelerationValue[1] * accelerationValue[1] + accelerationValue[2] * accelerationValue[2]);
 
 if(length >= 0.1)
 {
 bzero(matrix, sizeof(matrix));
 matrix[3][3] = 1.0;
 
 // set up first matrix column as gravity vector
 matrix[0][0] = accelerationValue[0] / length;
 matrix[0][0] = accelerationValue[0] / length;
 matrix[0][0] = accelerationValue[0] / length;
 
 // set up second matrix column as an arbitrary vector in the plane perpendicular to the gravity vector
 // {Gx, Gy, Gz} defined by the equation "Gx * x + Gy * y + Gz * z = 0" in which we arbitrarily set x = 0 and y = 1
 matrix[1][0] = 0.0;
 matrix[1][1] = 1.0;
 matrix[1][2] = -accelerationValue[1] / accelerationValue[2];
 length = sqrtf(matrix[1][0] * matrix[1][0] + matrix[1][1] * matrix[1][1] + matrix[1][2] * matrix[1][2]);
 matrix[1][0] /= length;
 matrix[1][1] /= length;
 matrix[1][2] /= length;
 
 // set up a third matrix column as a cross product of the first two
 matrix[2][0] = matrix[0][1] * matrix[1][2] - matrix[0][2] * matrix[1][1];
 matrix[2][1] = matrix[1][0] * matrix[0][2] - matrix[1][2] * matrix[0][0];
 matrix[2][2] = matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
 
 // finally load matrix
 glMultMatrixf((GLfloat *)matrix);
 
 // rotate a bit more so that it's where we want it
 glRotatef(90.0, 0.0, 0.0, 1.0);		    
 }
 }
 }
 */

-(void) updateScreenShake:(float) deltaTime
{
	// calculate the screen shake (jitter) on the x,y,z axes
	if (jitter > 0.0f)
	{
		jitterCamera.x = jitter*((JITTER_AMP*rand() / RAND_MAX)-0.1);
		jitterCamera.y = jitter*((JITTER_AMP*rand() / RAND_MAX)-0.1);
		jitterCamera.z = jitter*((JITTER_AMP*rand() / RAND_MAX)-0.1);
		
		// linear decay of jitter
		jitter -= deltaTime;
		
		jitter = jitter < 0.0f ? 0.0f : jitter;
	}
	else
	{
		jitterCamera.x = jitterCamera.y = jitterCamera.z = 0.0f;
	}
}

-(void) updateCamera
{
	// grab the tilt, needed only to rotate the camera to the right angle
	float aGx = RadiansToDegrees(accelerationValue[0])-90.0f;
	float aGy = RadiansToDegrees(accelerationValue[1])-90.0f;
	
	activeCamera.rotation = cc3v(-aGy*CAMERA_ANGLE_SCALE+jitterCamera.x,+aGx*CAMERA_ANGLE_SCALE+jitterCamera.y , 0+jitterCamera.z);
	
	activeCamera.location = cc3v(pigX-ZOOM*sin(DegreesToRadians(-aGx*CAMERA_ANGLE_SCALE)), pigY-ZOOM*sin(DegreesToRadians(-aGy*CAMERA_ANGLE_SCALE)), pigZ+ZOOM*cos(DegreesToRadians(-aGy*CAMERA_ANGLE_SCALE))*cos(DegreesToRadians(-aGx*CAMERA_ANGLE_SCALE))); 
	
}

- (void)updateCameraFromControls:(ccTime)dt
{	
	// update the location of the player (camera)
	if(playerLocationControl.x || playerLocationControl.y)
	{
		// get the x-y delta value of the control and scale it to something suitable
		CGPoint delta = ccpMult(playerLocationControl, dt * 100.0);
		
		// we want to move the camera up and down and side to side. Up will always be
		// world up (typically Y - axis), and side to side will be a line in the X-Z plane
		// along the "right" vector of the camera. Since the world up is orthogonal to the
		// X - Z plane, for convenience, combine these two axes (world up and camera right)
		// into a single control vector by simply adding them. You could also run these 
		// calculations independently instead of combining into one vector
		CC3Vector controlVector = CC3VectorAdd(activeCamera.rightDirection, activeCamera.worldUpDirection);
		
		// Scale the control vector by the control delta, using the X - component of the control
		// delta value for both the X and Z axes of the camera's right vector. this represents
		// the movement of the camera. the new location is simply the old location plus the movement
		activeCamera.location = CC3VectorAdd(activeCamera.location, CC3VectorScale(controlVector, cc3v(delta.x, delta.y, delta.x)));
		
		//[self shatter];
	}
	
	// update the direction the camera is pointing by panning and inclining
	if(playerDirectionalControl.x || playerDirectionalControl.y)
	{
		CGPoint delta = ccpMult(playerDirectionalControl, dt * 30.0); // factor to set the speed of rotation
		CC3Vector camRot = activeCamera.rotation;
		camRot.y -= delta.x;
		camRot.x += delta.y;
		activeCamera.rotation = camRot;
		
		//CC3MeshNode *pigMesh = (CC3MeshNode *)[pigResource getNodeNamed:@"Final_Pig"];
		//CC3Vector pigRot = pigMesh.rotation;
		//pigRot.x += delta.x;
		//pigRot.y += delta.y;
		//pigMesh.rotation = pigRot;
		
		//[pigTemplate runAction:[CC3RotateTo actionWithDuration:deltaTime rotateTo:pigRot]];
		//pigResourceNode.rotation = pigRot;
	}
}

-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint 
{
	// simply add some jitter the screen when a touch begins
	if (touchType == kCCTouchBegan)
	{
		jitter += 0.2f;
		jitter = (jitter > MAX_JITTER) ? MAX_JITTER : jitter;
	}
	
}

@end

#pragma mark -
#pragma mark IntroducingPODResource

@implementation IntroducingPODResource

/**
 * Return a customized light class, to handle the idiosyncracies of the way the original
 * PVR demo app uses the POD file data. This shouldn't usually be necessary.
 */
-(CC3Light*) buildLightAtIndex: (uint) lightIndex {
	return [IntroducingPODLight nodeAtIndex: lightIndex fromPODResource: self];
}

/**
 * The PVRT example ignores all but ambient and diffuse material properties from the POD
 * file and uses default values instead. To duplicate...force other properties to defaults.
 */
-(CC3Material*) buildMaterialAtIndex: (uint) materialIndex {
	CC3Material* mat = [super buildMaterialAtIndex: materialIndex];
	mat.specularColor = kCC3DefaultMaterialColorSpecular;
	mat.emissionColor = kCC3DefaultMaterialColorEmission;
	mat.shininess = kCC3DefaultMaterialShininess;
	return mat;
}

@end


#pragma mark -
#pragma mark IntroducingPODLight

@interface CC3Node (TemplateMethods)
-(void) applyTranslation;
@end

@implementation IntroducingPODLight

/**
 * Idiosyncratically...the PVRT example that this demo is taken from actually extracts
 * the transformed UP DIRECTION from the POD file and uses it as the light POSITION.
 */
-(void) applyTranslation {
	[super applyTranslation];
	GLfloat w = isDirectionalOnly ? 0.0f : 1.0f;
	CC3Vector dir = self.upDirection;
	homogeneousLocation = CC3Vector4FromCC3Vector(dir, w);
	LogTrace(@"Updating homoLoc to upDir in %@ to %@", self, NSStringFromCC3Vector4(homogeneousLocation));
}

/** Although the POD file contains direction info, it is ignored in this demo (as in the PVRT example). */
-(void) applyDirection {}

/** 
 * Although the POD file contains light color info, it is ignored in this demo (as in the PVRT example)
 * and the GL default values are used instead.
 */
-(void) applyColor {
	gles11Light.ambientColor.value = kCC3DefaultLightColorAmbient;
	gles11Light.diffuseColor.value = kCC3DefaultLightColorDiffuse;
	gles11Light.specularColor.value = kCC3DefaultLightColorSpecular;
}

@end

