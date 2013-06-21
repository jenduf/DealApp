//
//  PimpResultsViewController.m
//  DealShaker
//
//  Created by Jennifer Duffey on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PimpResultsViewController.h"
#import "DealShakerAppDelegate.h"
#import "Constants.h"
#import "PimpIcon.h"
#import "DataArchiver.h"
#import "Screenshot.h"

@implementation PimpResultsViewController
@synthesize decalImageView, glassesImageView, hatsImageView, mouthImageView, imageDictionary, screenShotContainer, messageLabel;
@synthesize shareButton, activityIndicator;

- (id)initWithImageDictionary:(NSDictionary *)imageDict
{
    self = [super initWithNibName:@"PimpResultsViewController" bundle:nil];
	
    if (self) 
    {
	    imageDictionary = [[NSDictionary alloc] initWithDictionary:imageDict];
    }
	
    return self;
}

- (void)dealloc
{
	[decalImageView release];
	[glassesImageView release];
	[hatsImageView release];
	[mouthImageView release];
	[imageDictionary release];
	[screenShotContainer release];
	[messageLabel release];
	[shareButton release];
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
	
	self.title = @"Pimp My Pig";

	PimpIcon *decalIcon = (PimpIcon *)[imageDictionary objectForKey:DECAL_ROW];
	decalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"addons_%@_large.png", decalIcon.selectedIndex]];
	PimpIcon *glassesIcon = (PimpIcon *)[imageDictionary objectForKey:GLASSES_ROW];
	glassesImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"addons_%@_large.png", glassesIcon.selectedIndex]];
	PimpIcon *hatsIcon = (PimpIcon *)[imageDictionary objectForKey:HAT_ROW];
	hatsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"addons_%@_large.png", hatsIcon.selectedIndex]];
	PimpIcon *mouthIcon = (PimpIcon *)[imageDictionary objectForKey:MOUTH_ROW];
	mouthImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"addons_%@_large.png", mouthIcon.selectedIndex]];

}

- (IBAction)sharePig:(id)sender
{
	[messageLabel setHidden:YES];
	
	DealShakerAppDelegate *appDelegate = (DealShakerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSArray *permissions = [[NSArray arrayWithObjects:@"read_stream", @"offline_access", @"publish_stream", nil] retain];
	
	if(![appDelegate.facebook isSessionValid])
	{
		[appDelegate.facebook authorize:permissions delegate:self];
	}
	else
	{
		[self uploadPhoto];
	}
	
	[FlurryAnalytics logEvent:FLURRY_SHARED_PIG];
}

- (void)uploadPhoto
{
	DealShakerAppDelegate *appDelegate = (DealShakerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UIImage *screenShot = (UIImage *)[screenShotContainer screenshot];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
							 @"DealShaker", @"name",
							 @"App Photos", @"category",
							screenShot, @"picture",
							@"I pimped my pig on the NEW DealShaker iPhone App", @"caption",
							 nil];
	
	[activityIndicator startAnimating];
	[shareButton setEnabled:NO];
	
	[appDelegate.facebook requestWithMethodName:@"photos.upload" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.decalImageView = nil;
	self.glassesImageView = nil;
	self.hatsImageView = nil;
	self.mouthImageView = nil;
	self.imageDictionary = nil;
	self.screenShotContainer = nil;
	self.messageLabel = nil;
	self.shareButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Facebook Delegate Methods
/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
	NSLog(@"FB Login Complete");
	[self uploadPhoto];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"FB Login Cancelled");
}

- (void)dialogDidComplete:(FBDialog *)dialog
{
	NSLog(@"Success!");
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
	NSLog(@"Facebook Error: %@", [error localizedDescription]);
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"%@", response);
}

- (void)requestLoading:(FBRequest *)request
{
	
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
	if ([result isKindOfClass:[NSArray class]]) 
	{
		result = [result objectAtIndex:0];
	}
	
	if ([result objectForKey:@"owner"]) 
	{
		NSLog(@"Photo upload success");
	} 
	else 
	{
		NSLog(@"Photo upload success 2");
	}
	
	[activityIndicator stopAnimating];
	
	[shareButton setEnabled:YES];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your pig has been shared" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//[self.label setText:[error localizedDescription]];
	NSLog(@"%@", [error localizedDescription]);
}

@end
