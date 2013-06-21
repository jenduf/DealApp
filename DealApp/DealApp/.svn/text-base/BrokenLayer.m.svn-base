//
//  BrokenLayer.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrokenLayer.h"
#import "Constants.h"
#import "SceneManager.h"
#import "Deal.h"

@implementation BrokenLayer

+ (id)scene
{
	CCScene *scene = [CCScene node];
	BrokenLayer *layer = [BrokenLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init
{
	self = [super init];
	
	if (self) 
	{
		[[SceneManager sharedSceneManager] playSoundEffect:SOUND_BREAK_KEY];
		
		self.isAccelerometerEnabled = NO;
		
		deal = (Deal *)[[SceneManager sharedSceneManager] getRandomDeal];
		
		emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:EXPLOSION_FILE];
		emitter.autoRemoveOnFinish = YES;
		[self addChild:emitter z:1 tag:0];
		
		//[[NSNotificationCenter defaultCenter] postNotificationName:NOTE_GRAB_DEAL object:nil userInfo:[deal convertToDictionary]];
		[self createDealBanner];
          
        //  [self addButton];
	}
	
	return self;
}

- (void)addButton
{
	CCMenuItem *tryAgainMenuItem = [CCMenuItemImage itemFromNormalImage:TRY_AGAIN_BUTTON selectedImage:nil target:self selector:@selector(showIntroScene)];
	tryAgainMenuItem.position = ccp(SHAKE_BUTTON_X, SHAKE_BUTTON_Y);
	CCMenu *tryAgainMenu = [CCMenu menuWithItems:tryAgainMenuItem, nil];
	tryAgainMenu.position = CGPointZero;
	[self addChild:tryAgainMenu z:1 tag:0];
}

- (void)createDealBanner
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	//ccColor3B menuColor =  ccc3(44, 124, 161);
	
	// Menu Background
	CCSprite *backgroundSprite = [CCSprite spriteWithFile:DEAL_BANNER];
	backgroundSprite.position = ccp(screenSize.width/2, screenSize.height/2);
	backgroundSprite.scale = 0;
	[self addChild:backgroundSprite z:1];
	
	CCScaleTo *scale = [CCScaleTo actionWithDuration:.25 scale:1];
	CCDelayTime *delay = [CCDelayTime actionWithDuration:.5];
	CCSequence *seq = [CCSequence actions:delay, scale, [CCCallFuncND actionWithTarget:self selector:@selector(scaleComplete) data:nil], nil];
	[backgroundSprite runAction:seq];
	
	/*
	
	// Menu Title
	CCLabelTTF *dealTitleLabel = [CCLabelTTF labelWithString:deal.merchantName dimensions:CGSizeMake(SHAKE_BANNER_WIDTH, SHAKE_BANNER_HEIGHT) alignment:UITextAlignmentLeft lineBreakMode:CCLineBreakModeWordWrap fontName:@"Helvetica-Bold" fontSize:22.0];
	[dealTitleLabel setColor:menuColor];
	CCMenuItemLabel *menuTitleLabel = [CCMenuItemLabel itemWithLabel:dealTitleLabel];
	menuTitleLabel.position = ccp(0,0);
	menuTitleLabel.tag = MENU_ITEM_ONE;
	//menuTitleLabel.anchorPoint = ccp(1, 1);
	
	// Menu Title
	CCLabelTTF *dealDescriptionLabel = [CCLabelTTF labelWithString:deal.label dimensions:CGSizeMake(SHAKE_BANNER_WIDTH, SHAKE_BANNER_HEIGHT) alignment:UITextAlignmentLeft lineBreakMode:CCLineBreakModeWordWrap fontName:@"Helvetica-Bold" fontSize:15.0];
	[dealDescriptionLabel setColor:menuColor];
	CCMenuItemLabel *menuDescriptionLabel = [CCMenuItemLabel itemWithLabel:dealDescriptionLabel];
	menuDescriptionLabel.position = ccp(0,-40);
	
	// Grab Button
	CCMenuItemImage *grabItemImage = [CCMenuItemImage itemFromNormalImage:GRAB_IT_BUTTON selectedImage:GRAB_IT_BUTTON target:self selector:@selector(dealGrabbed:)];
	grabItemImage.position = ccp(15,-80);
	grabItemImage.tag = MENU_ITEM_TWO;
	
	CCMenuItemImage *tryAgainImage = [CCMenuItemImage itemFromNormalImage:TRY_AGAIN_BUTTON selectedImage:TRY_AGAIN_BUTTON target:self selector:@selector(dealGrabbed:)];
	tryAgainImage.position = ccp(5,-80);
	tryAgainImage.tag = MENU_ITEM_THREE;

	dealMenu = [CCMenu menuWithItems:menuTitleLabel, menuDescriptionLabel, grabItemImage, tryAgainImage, nil];
	dealMenu.position = ccp(screenSize.width/2, screenSize.height/2);
	//[dealMenu alignItemsVertically];
	
	//[dealMenu addChild:menuBackgroundImage z:-1];
	
	[self addChild:dealMenu z:2 tag:0];*/
	
	//CCMoveTo *move = [CCMoveTo actionWithDuration:.25 position:ccp(screenSize.width/2, screenSize.height/2)];
	//CCSequence *seq2 = [CCSequence actionOne:delay two:move];
	//[dealMenu runAction:seq];
}

- (void)scaleComplete
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTE_GRAB_DEAL object:nil userInfo:[deal convertToDictionary]];
	
	[[SceneManager sharedSceneManager] playSoundEffect:SOUND_SUCCESS_KEY];
}

- (void)dealGrabbed:(id)sender
{	
	if(deal != nil)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTE_GRAB_DEAL object:nil userInfo:[deal convertToDictionary]];
	}
	
	//remove previous menu items
	[self removeChild:dealMenu cleanup:NO];
	
	// Menu Background
	/*CCMenuItemImage *menuBackgroundImage = [CCMenuItemImage itemFromNormalImage:DEAL_GRABBED_BANNER selectedImage:nil target:self selector:@selector(showIntroScene)];
	menuBackgroundImage.position = CGPointZero;
	
	CCMenuItemImage *keepShakingImage = [CCMenuItemImage itemFromNormalImage:KEEP_SHAKING_BUTTON selectedImage:nil target:self selector:nil];
	keepShakingImage.position = ccp(0, -80);
	
	grabMenu = [CCMenu menuWithItems:menuBackgroundImage, keepShakingImage, nil];
	grabMenu.position = dealMenu.position;
	
	[self addChild:grabMenu z:2 tag:0];*/
}
		 
@end
