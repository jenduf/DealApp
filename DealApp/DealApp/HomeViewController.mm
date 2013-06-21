//
//  FirstViewController.m
//  DealShaker
//
//  Created by Jennifer Duffey on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "Constants.h"
#import "SceneManager.h"
#import "Deal.h"
#import "RestClient.h"
#import "ShareViewController.h"

@implementation HomeViewController
@synthesize shakeViewHolder, grabView, titleLabel, descriptionLabel, logoImage, adButton, adTimer;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self go3D:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[FlurryAnalytics logEvent:FLURRY_HOME];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self reset];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationController setNavigationBarHidden:YES];
	
	[self loadDeals];
	
	[[BlockdotAdService sharedInstance] startDownloadWithGameID: kGameID 
										    platformID: kGameAdPlatform
											  version: kGameAdVersion 
											   sizeID: kGameAdSize
										 orientationID: kGameAdOrientation
											 delegate: self];	
	
	showingAd = NO;
}

- (void)loadDeals
{
	//[RestClient requestDealsWithCallback:self];
	[RestClient requestDealsByCategory:HOT_CATEGORY_ID withLimit:10 callback:self];
}

- (void)onDealsSuccess:(NSArray *)arr
{
	NSLog(@"deals loaded");
}

- (void)onDealsError
{
	NSLog(@"Deals Error");
}

- (void)onDealsByCategorySuccess:(NSArray *)arr
{
	NSLog(@"deals loaded");
}

- (void)onDealsByCategoryError
{
	NSLog(@"Deals By Category Error");
}

- (void)reset
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	UIView *view = [self.view viewWithTag:999];
	[view removeFromSuperview];
	[grabView removeFromSuperview];
	[glView removeFromSuperview];
	[[CCDirector sharedDirector] end];
}

- (void)go3D:(id)sender
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealGrabbed:) name:NOTE_GRAB_DEAL object:nil];
	
	self.view.alpha = 0.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	
	self.view.alpha = 1.0; 
	[UIView commitAnimations];
	
	
	if(! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	CCDirector *director = [CCDirector sharedDirector];
	
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	glView = [EAGLView viewWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT) pixelFormat:kEAGLColorFormatRGBA8 depthFormat:GL_DEPTH_COMPONENT16_OES];
	
	[director setOpenGLView:glView];
	
	[shakeViewHolder addSubview:glView];
	
	[[SceneManager sharedSceneManager] setupAudioEngine];
	
	[[SceneManager sharedSceneManager] runSceneWithID:kOpenScene];

}

- (void)dealGrabbed:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	randomDeal = [[Deal alloc] initWithDictionary:dict];
	
	titleLabel.text = randomDeal.merchantName;
	descriptionLabel.text = randomDeal.label;
	
	[self.view addSubview:grabView];
}

- (void)closeShare:(NSNotification *)note
{
	[self reset];
	[self go3D:nil];
} 

- (IBAction)keepShaking:(id)sender
{
	[self reset];
	[self go3D:nil];
}

- (IBAction)grabDeal:(id)sender
{
	[grabView removeFromSuperview];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeShare:) name:NOTE_CLOSE_SHARE object:nil];
	
	ShareViewController *shareViewController = [[ShareViewController alloc] initWithDeal:randomDeal forState:STATE_GRAB];
	shareViewController.view.tag = 999;
	[self.view addSubview:shareViewController.view];
}

- (void)fadeAnimation
{
	if(showingAd == NO)
	{
		logoImage.alpha = 1.0;
		adButton.alpha = 0.0;
		
		[UIView beginAnimations:@"fade" context:NULL];
		[UIView setAnimationDuration:3];
		[UIView setAnimationDelegate:self];
		logoImage.alpha = 0.0;
		adButton.alpha = 1.0;
		[UIView commitAnimations];
	}
	else
	{
		logoImage.alpha = 0.0;
		adButton.alpha = 1.0;
		
		[UIView beginAnimations:@"fade" context:NULL];
		[UIView setAnimationDuration:3];
		[UIView setAnimationDelegate:self];
		logoImage.alpha = 1.0;
		adButton.alpha = 0.0;
		[UIView commitAnimations];
	}
	
	showingAd = !showingAd;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.shakeViewHolder = nil;
	self.grabView = nil;
	self.titleLabel = nil;
	self.descriptionLabel = nil;
	self.logoImage = nil;
	self.adButton = nil;
}


- (void)dealloc
{
	[[CCDirector sharedDirector] release];
	
	if(adTimer != nil)
	{
		[adTimer invalidate];
		adTimer = nil;
	}
	
	[shakeViewHolder release];
	[grabView release];
	[titleLabel release];
	[descriptionLabel release];
	[logoImage release];
	[adButton release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Ad Delegate Methods
- (void)adDownloaded: (BlockdotAdService *) ad 
{
	if (ad.available) 
	{
		// Add the ad to the scene
		int w = ad.image.size.width;
		int h = ad.image.size.height;
		
		adButton.showsTouchWhenHighlighted = YES;
		[adButton setImage: ad.image forState: UIControlStateNormal];
		[adButton setImage: ad.image forState: UIControlStateHighlighted];

		adButton.frame = CGRectMake(self.view.frame.size.width/2 - w/2, 20, w, h);
		
		adTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(fadeAnimation) userInfo:nil repeats:YES];
		
		[self fadeAnimation];
	}
}

- (IBAction)adTouched:(id)sender
{
	[FlurryAnalytics logEvent:FLURRY_AD_TOUCHED];
	
	NSString* url = [BlockdotAdService sharedInstance].link;
	
	BOOL success = [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
	
	if (success == NO) 
	{
		NSLog(@"Couldn't load URL: %@", url);
	}
}

@end
