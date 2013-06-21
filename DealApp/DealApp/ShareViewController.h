//
//  ShareViewController.h
//  DealShaker
//
//  Created by Jennifer Duffey on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class Deal;
@interface ShareViewController : UIViewController
<FBDialogDelegate, FBRequestDelegate, FBSessionDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>
{
	Deal *deal;
	UIView *shareView, *grabView, *emailView;
	UITextField *emailTextField;
	
	UILabel *emailTextLabel;
	
	NSString *emailAddress;
	
	int currentState;
}

@property (nonatomic, retain) Deal *deal;
@property (nonatomic, retain) IBOutlet UIView *shareView, *grabView, *emailView;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UILabel *emailTextLabel;
@property (nonatomic, retain) NSString *emailAddress;

- (id)initWithDeal:(Deal *)_deal forState:(int)state;
- (void)handleGrab;
- (void)handleShare;
- (void)handleUpdate;
- (IBAction)saveEmail:(id)sender;
- (IBAction)closeGrab:(id)sender;
- (IBAction)clickedToShare:(id)sender;
- (void)postToFacebook;
- (void)postToTwitter;
- (void)postToEmail;
- (void)publishDeal;
- (void)showAlertWithMessage:(NSString *)message;

@end
