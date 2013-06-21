//
//  ShareViewController.m
//  DealShaker
//
//  Created by Jennifer Duffey on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "Constants.h"
#import "Deal.h"
#import "DealShakerAppDelegate.h"
#import "Utils.h"
#import "RestClient.h"

@implementation ShareViewController
@synthesize deal, shareView, grabView, emailView, emailAddress, emailTextField, emailTextLabel;

- (id)initWithDeal:(Deal *)_deal forState:(int)state
{
    
	self = [super initWithNibName:@"ShareViewController" bundle:nil];
    
	if (self) 
	{
        // Custom initialization
		deal = [_deal retain];
		currentState = state;
	}
    
	return self;
}

- (void)onEmailDealsSuccess:(NSString *)msg
{
	NSLog(@"email success");
	[self showAlertWithMessage:msg];
}

- (void)onEmailDealsError
{
	NSLog(@"Email Error");
	[self showAlertWithMessage:@"Unable to send e-mail."];
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
	
	switch (currentState) 
	{
		case STATE_GRAB:
			[self handleGrab];
			break;
			
		case STATE_SHARE:
			[self handleShare];
			break;
			
		case STATE_UPDATE:
			[self handleUpdate];
			break;
			
		default:
			break;
	}
	
	
}

- (void)showAlertWithMessage:(NSString *)message
{
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[self closeGrab:nil];
}

- (void)handleGrab
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	emailAddress = [[defaults stringForKey:USER_EMAIL_ADDRESS] retain];
	
	if(emailAddress != nil)
	{
		[RestClient requestEmailat:emailAddress forDealID:[deal.dealID intValue] callback:self];
		
		/*
		NSString* subject = @"DealShaker Deal";
		NSString* body = [NSString stringWithFormat:@"Check out this awesome Deal from %@:\n\n %@ \n\n <a href=\"%@\">%@</a>", deal.merchantName, deal.label, deal.postURL, deal.postURL];
		
		NSString* url = [NSString stringWithFormat: @"mailto:%@?subject=%@&body=%@", emailAddress, subject, body];
		
		NSString *formattedURL = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		
		Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
		if (mailClass != nil)
		{
			// We must always check whether the current device is configured for sending emails
			if ([mailClass canSendMail])
			{
				MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
				mailController.mailComposeDelegate = self;
				[mailController setToRecipients:[NSArray arrayWithObject:emailAddress]];
				[mailController setSubject:subject];
				[mailController setMessageBody:body isHTML:YES];
				[self presentModalViewController:mailController animated:YES];
			}
			else
			{
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedURL]];
			}
		}
		else
		{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedURL]];
		}
		
		[self.view addSubview:grabView];*/
	}
	else
	{
		emailTextLabel.text = @"Enter your email address to receive your grabbed DealTaker Deals!";
		[self.view addSubview:emailView];
	}
}

- (void)handleShare
{
	[self.view addSubview:shareView];
}

- (void)handleUpdate
{
	emailTextLabel.text = @"Enter your email address to receive your grabbed DealTaker Deals!";
	[self.view addSubview:emailView];
}

- (IBAction)clickedToShare:(id)sender
{
	int index = [sender tag];
	
	switch(index)
	{
		case SHARE_FACEBOOK:
			[self postToFacebook];
			break;
			
		case SHARE_TWITTER:
			[self postToTwitter];
			break;
			
		case SHARE_EMAIL:
			[self postToEmail];
			break;
	}
	
	[shareView removeFromSuperview];
}

- (IBAction)saveEmail:(id)sender
{
	if(currentState == STATE_SHARE)
	{
		[RestClient requestEmailat:emailTextField.text forDealID:[deal.dealID intValue] callback:self];
	}
	else
	{
		if(emailTextField.text != nil && [Utils validateEmailAddress:emailTextField.text])
		{
			emailAddress = [emailTextField.text retain];
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:emailAddress forKey:USER_EMAIL_ADDRESS];
			[defaults synchronize];
			
			[emailView removeFromSuperview];
			
			if(currentState == STATE_GRAB)
				[self handleGrab];
			else
				[self showAlertWithMessage:@"Your e-mail has been successfully updated!"];
		}
		else
		{
			NSString *title;
			NSString *message;
			
			if(emailTextField.text == nil)
			{
				title = @"Missing Email";
				message = @"Please enter your e-mail address";
			}
				
			else
			{
				title = @"Invalid Email";
				message = @"Please enter a valid e-mail address";
			}
			
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
			[alertView show];
		}
	}
}

- (IBAction)closeGrab:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
	[self.view removeFromSuperview];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTE_CLOSE_SHARE object:nil];
}

- (void)postToFacebook
{
	[self closeGrab:nil];
	
	DealShakerAppDelegate *appDelegate = (DealShakerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSArray *permissions = [[NSArray arrayWithObjects:@"read_stream", @"offline_access", @"publish_stream", nil] retain];
	
	if(![appDelegate.facebook isSessionValid])
	{
		[appDelegate.facebook authorize:permissions delegate:self];
	}
	else
	{
		[self publishDeal];
	}
}

- (void)postToTwitter
{
	NSString *status = [NSString stringWithFormat:@"Check out this great deal from: %@ %@ brought to you by DealTaker.com", deal.merchantName, deal.label]; 
	status = [status stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[self closeGrab:nil];
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://m.twitter.com/?status=%@", status]]];
}

- (void)postToEmail
{
	emailTextLabel.text = @"Enter the email address you would like to share this DealTaker Deal with!";
	[self.view addSubview:emailView];
}

- (void)publishDeal
{
	DealShakerAppDelegate *appDelegate = (DealShakerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
							 FACEBOOK_APP_ID, @"app_id",
							 deal.postURL, @"link",
							 deal.merchantImageURL, @"picture",
							 deal.merchantName, @"name",
							 @"Check out this deal I grabbed from Deal Taker's NEW iPhone / iPad App", @"caption",
							 deal.label, @"description",
							 nil];
	
	[appDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.deal = nil;
	self.shareView = nil;
	self.grabView = nil;
	self.emailView = nil;
	self.emailAddress = nil;
	self.emailTextField = nil;
	self.emailTextLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
	[deal release];
	[shareView release];
	[grabView release];
	[emailView release];
	[emailAddress release];
	[emailTextField release];
	[emailTextLabel release];
	[super dealloc];
}

#pragma mark -
#pragma mark Mail Delegate Methods
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	NSString *strfinal = @"";
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			strfinal = @"Email send cancelled.";
			break;
		case MFMailComposeResultSaved:
			strfinal = @"Email send saved.";
			break;
		case MFMailComposeResultSent:
			strfinal = @"Email sent successfully.";
			break;
		case MFMailComposeResultFailed:
			strfinal = @"Email send failed.";
			break;
		default:
			strfinal = @"Unable to send e-mail.";
			break;
	}
	
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:strfinal delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Facebook Delegate Methods
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

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
	NSLog(@"FB Login Complete");
	[self publishDeal];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"FB Login Cancelled");
}

#pragma mark -
#pragma mark Text Field Delegate Methodsß
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self saveEmail:nil];
	
	return YES;
}

@end
