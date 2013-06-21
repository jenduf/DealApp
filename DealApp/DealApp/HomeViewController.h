//
//  FirstViewController.h
//  DealShaker
//
//  Created by Jennifer Duffey on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "BlockdotAdService.h"

@class Deal;
@interface HomeViewController : UIViewController
<BlockdotAdServiceDelegate>
{
	UIImageView *logoImage;
	UIButton *adButton;
	
	UILabel *titleLabel, *descriptionLabel;
	
	EAGLView *glView;
	
	UIView *shakeViewHolder, *grabView;
	
	Deal *randomDeal;
	
	NSTimer *adTimer;
	
	BOOL showingAd;
}

@property (nonatomic, retain) IBOutlet UIView *shakeViewHolder, *grabView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel, *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *logoImage;
@property (nonatomic, retain) IBOutlet UIButton *adButton;
@property (nonatomic, retain) NSTimer *adTimer;

- (void)loadDeals;
- (void)go3D:(id)sender;
- (void)reset;
- (IBAction)keepShaking:(id)sender;
- (IBAction)grabDeal:(id)sender;
- (IBAction)adTouched:(id)sender;
- (void)fadeAnimation;

@end
