//
//  DetailViewController.m
//  DealShaker
//
//  Created by Jennifer Duffey on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "DealShakerAppDelegate.h"
#import "Deal.h"
#import "RestClient.h"
#import "CategoryVO.h"
#import "Utils.h"
#import "Constants.h"
#import "ShareViewController.h"

@implementation DetailViewController
@synthesize dealTitleLabel, dealDescriptionLabel, dealRestrictionsLabel, dealCategoryLabel, dealExpirationLabel, dealPostedLabel;
@synthesize dealImageView, categoryBadgeView, deal, category;

- (id)initWithDeal:(Deal *)_deal forCategory:(CategoryVO *)cat
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
	
    if (self) 
    {
	    deal = [_deal retain];
	    
	    category = [cat retain];
    }
    
	return self;
}

- (void)dealloc
{
	[dealTitleLabel release];
	[dealDescriptionLabel release];
	[dealRestrictionsLabel release];
	[dealCategoryLabel release];
	[dealExpirationLabel release];
	[dealPostedLabel release];
	[dealImageView release];
	[categoryBadgeView release];
	[deal release];
	[category release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"Deal";
	
	/*if([deal.primaryCategoryID isEqualToString:@"0"])
	{
		for(NSString *str in deal.categoryIDs)
		{
			deal.primaryCategoryID = str;
		}
	}*/
	[self refreshView];
	//[RestClient requestCategoryByCategoryID:categoryID callback:self];
}

- (void)onCategoryByIDSuccess:(CategoryVO *)cat
{
	if(cat != nil)
	{
		deal.categoryName = cat.label;
		[self refreshView];
	}
}

- (void)onCategoryByIDError
{
	NSLog(@"Category By ID Error");
}

- (void)refreshView
{
	dealTitleLabel.text = deal.merchantName;
	dealDescriptionLabel.text = deal.label;
	dealRestrictionsLabel.text = deal.restrictions;
	dealCategoryLabel.text = category.label;
	dealPostedLabel.text = [Utils getDateStringFromTimeInterval:deal.addedDate];
	dealExpirationLabel.text = [Utils getDateStringFromTimeInterval:deal.endDate];
	categoryBadgeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"cat_%@.png", category.category_id]];
	dealImageView.image = deal.merchantImage;
}

- (IBAction)grabIt:(id)sender
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeShare:) name:NOTE_CLOSE_SHARE object:nil];
	
	ShareViewController *shareViewController = [[ShareViewController alloc] initWithDeal:deal forState:STATE_GRAB];
	[self.view addSubview:shareViewController.view];
}

- (void)closeShare:(NSNotification *)note
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	//[self reset];
}

- (IBAction)shareIt:(id)sender
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeShare:) name:NOTE_CLOSE_SHARE object:nil];
	
	ShareViewController *shareViewController = [[ShareViewController alloc] initWithDeal:deal forState:STATE_SHARE];
	[self.view addSubview:shareViewController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.dealTitleLabel = nil;
	self.dealDescriptionLabel = nil;
	self.dealRestrictionsLabel = nil;
	self.dealCategoryLabel = nil;
	self.dealExpirationLabel = nil;
	self.dealPostedLabel = nil;
	self.dealImageView = nil;
	self.categoryBadgeView = nil;
	self.deal = nil;
	self.category = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
