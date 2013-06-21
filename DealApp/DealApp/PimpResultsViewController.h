//
//  PimpResultsViewController.h
//  DealShaker
//
//  Created by Jennifer Duffey on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface PimpResultsViewController : UIViewController 
<FBDialogDelegate, FBRequestDelegate, FBSessionDelegate>
{
	UIImageView *decalImageView, *glassesImageView, *hatsImageView, *mouthImageView;
	UIActivityIndicatorView *activityIndicator;
	UIButton *shareButton;
	NSDictionary *imageDictionary;
	UIView *screenShotContainer;
	UILabel *messageLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *decalImageView, *glassesImageView, *hatsImageView, *mouthImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) IBOutlet UIView *screenShotContainer;
@property (nonatomic, retain) NSDictionary *imageDictionary;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;

- (id)initWithImageDictionary:(NSDictionary *)imageDict;
- (IBAction)sharePig:(id)sender;
- (void)uploadPhoto;

@end
