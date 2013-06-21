//
//  SearchViewController.m
//  DealShaker
//
//  Created by Jennifer Duffey on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PimpViewController.h"
#import "PimpResultsViewController.h"
#import "PimpIcon.h"
#import "Constants.h"
#import "DataArchiver.h"

@implementation PimpViewController
@synthesize selectedImages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
	
    return self;
}

- (IBAction)clickIcon:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	int index = btn.tag;
	BOOL isSelected = btn.selected;
	
	// get the first item on the selected row and toggle all icons to off state
	int firstItem = index - ((index + 2) % 3);
	
	[self toggleButtonsAtIndex:index withMin:firstItem andMax:(firstItem + 3) selected:!isSelected];
}

- (void)toggleButtonsAtIndex:(int)selIndex withMin:(int)min andMax:(int)max selected:(BOOL)selected
{
	UIImage *selectedImage = nil;
	NSString *imageName = [NSString stringWithFormat:@"%i", selIndex];
	NSString *indexName = [NSString stringWithFormat:@"%i", min];
	
	PimpIcon *pimpIcon = [PimpIcon pimpIconWithName:[self getImageNameFromIndex:selIndex] row:indexName andSelectedIndex:imageName];
	
	// toggle all buttons on selected row to off
	for(int i = min; i < max; i++)
	{
		UIButton *btn = (UIButton *)[self.view viewWithTag:i];
		[btn setSelected:NO];
	}
	
	// if image has already been stored, remove
	if([selectedImages count] > 0)
	{
		if([selectedImages objectForKey:indexName] != nil)
			[selectedImages removeObjectForKey:indexName];
	}
	
	if(selected)
	{
		// store new image name
		[selectedImages setObject:pimpIcon forKey:indexName];
		// set selected image to display on pig
		selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"addons_%i.png", selIndex]];
	}
	
	//toggle button selected to off or on
	UIButton *btn = (UIButton *)[self.view viewWithTag:selIndex];
	[btn setSelected:selected];
	
	// hide or show image on pig
	UIImageView *imageView = (UIImageView *)[self.view viewWithTag:(min + 14)];
	imageView.image = selectedImage;
}

- (IBAction)savePig:(id)sender
{
	NSEnumerator *enumerator = [selectedImages keyEnumerator];
	id key;
	
	while ((key = [enumerator nextObject])) 
	{
		PimpIcon *pi = (PimpIcon *)[selectedImages objectForKey:key];
		NSLog(@"Saving icon: %@", pi.imageName);
	}
	
	[DataArchiver saveData:selectedImages];
	
	PimpResultsViewController *pimpResultsViewController = [[PimpResultsViewController alloc] initWithImageDictionary:selectedImages];
	[self.navigationController pushViewController:pimpResultsViewController animated:YES];
}
					  
- (NSString *)getImageNameFromIndex:(int)index
{
	NSString *imageName;
	
	switch(index)
	{
		case PIMP_EYE_PATCH_INDEX:
			imageName = PIMP_EYE_PATCH;
			break;
			
		case PIMP_SUNGLASSES_INDEX:
			imageName = PIMP_SUNGLASSES;
			break;
			
		case PIMP_MONOCLE_INDEX:
			imageName = PIMP_MONOCLE;
			break;
			
		case PIMP_BASEBALL_CAP_INDEX:
			imageName = PIMP_BASEBALL_CAP;
			break;
			
		case PIMP_FANCY_HAT_INDEX:
			imageName = PIMP_FANCY_HAT;
			break;
			
		case PIMP_COWBOY_HAT_INDEX:
			imageName = PIMP_COWBOY_HAT;
			break;
			
		case PIMP_LIPS_INDEX:
			imageName = PIMP_LIPS;
			break;
			
		case PIMP_BEARD_INDEX:
			imageName = PIMP_BEARD;
			break;
			
		case PIMP_MOUSTACHE_INDEX:
			imageName = PIMP_MOUSTACHE;
			break;
		
		case PIMP_LIGHTNING_INDEX:
			imageName = PIMP_LIGHTNING;
			break;
			
		case PIMP_FLAME_INDEX:
			imageName = PIMP_FLAME;
			break;
			
		case PIMP_LOGO_INDEX:
			imageName = PIMP_LOGO;
			break;	
			
	}
	
	return imageName;
}

- (void)dealloc
{
	[selectedImages release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[FlurryAnalytics logEvent:FLURRY_PIMP_MY_PIG];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButtonItem;
	[backButtonItem release];
	
	//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//NSDictionary *dict = (NSDictionary *)[defaults objectForKey:@"Pig_Pimped"];
	NSDictionary *dict = (NSDictionary *)[DataArchiver retrieveData];
	
	if(dict != nil)
	{
		NSEnumerator *enumerator = [dict keyEnumerator];
		id key;
		
		while ((key = [enumerator nextObject])) 
		{
			PimpIcon *pimpIcon = (PimpIcon *)[dict objectForKey:key];
			[self toggleButtonsAtIndex:[pimpIcon.selectedIndex intValue] withMin:[pimpIcon.rowIndex intValue] andMax:([pimpIcon.rowIndex intValue] + 3) selected:YES];
		}
		
		selectedImages = [[NSMutableDictionary alloc] initWithDictionary:dict];
	}
	else
		selectedImages = [[NSMutableDictionary alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.selectedImages = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
