//
//  DetailViewController.h
//  DealShaker
//
//  Created by Jennifer Duffey on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class Deal, CategoryVO;
@interface DetailViewController : UIViewController
{
	UILabel *dealTitleLabel, *dealDescriptionLabel, *dealRestrictionsLabel;
	UILabel *dealCategoryLabel, *dealExpirationLabel, *dealPostedLabel;
	UIImageView *dealImageView, *categoryBadgeView;
	
	Deal *deal;
	
	CategoryVO *category;
}

@property (nonatomic, retain) IBOutlet UILabel *dealTitleLabel, *dealDescriptionLabel, *dealRestrictionsLabel;
@property (nonatomic, retain) IBOutlet UILabel *dealCategoryLabel, *dealExpirationLabel, *dealPostedLabel;
@property (nonatomic, retain) IBOutlet UIImageView *dealImageView, *categoryBadgeView;
@property (nonatomic, retain) Deal *deal;
@property (nonatomic, retain) CategoryVO *category;

- (id)initWithDeal:(Deal *)_deal forCategory:(CategoryVO *)cat;
- (void)refreshView;
- (IBAction)grabIt:(id)sender;
- (IBAction)shareIt:(id)sender;

@end
