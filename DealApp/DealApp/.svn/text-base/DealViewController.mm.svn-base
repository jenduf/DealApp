//
//  SecondViewController.m
//  DealShaker
//
//  Created by Jennifer Duffey on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DealViewController.h"
#import "RestClient.h"
#import "DetailViewController.h"
#import "Deal.h"
#import "CategoryVO.h"
#import "SearchResult.h"


@implementation DealViewController
@synthesize category, deals, dealTableView, imageDownloadsInProgress, activityIndicator, noMatchesLabel;

- (id)initWithCategory:(CategoryVO *)cat
{
	self = [super initWithNibName:@"DealViewController" bundle:nil];
	
	if(self)
	{
		category = [cat retain];
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = category.label;
	
	imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
	
	[activityIndicator startAnimating];
	
	[RestClient requestDealsByCategory:[category.category_id intValue] withLimit:100 callback:self];
}

- (void)onDealsByCategorySuccess:(NSArray *)arr
{
	[activityIndicator stopAnimating];
	
	deals = [[NSArray alloc] initWithArray:arr];
	[dealTableView reloadData];
}

- (void)onDealsByCategoryError
{
	NSLog(@"Deals By Category Error");
}

- (void)onDealSearchSuccess:(SearchResult *)result
{
	[activityIndicator stopAnimating];
	
	deals = [[NSArray alloc] initWithArray:result.deals];
	
	if(result.deals == nil || [result.deals count] == 0)
	{
		[noMatchesLabel setHidden:NO];
	}
	
	[dealTableView reloadData];
}

- (void)onDealSearchError
{
	[activityIndicator stopAnimating];
	NSLog(@"Deals Search Error");
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
	self.deals = nil;
	self.dealTableView = nil;
	self.imageDownloadsInProgress = nil;
	self.activityIndicator = nil;
	self.noMatchesLabel = nil;
}


- (void)dealloc
{
	[deals release];
	[dealTableView release];
	[activityIndicator release];
	[imageDownloadsInProgress release];
	[noMatchesLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	
	return [deals count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell...
	Deal *deal = [deals objectAtIndex:indexPath.row];
	cell.textLabel.text = deal.merchantName;
	cell.detailTextLabel.text = deal.label;
	
	if(!deal.merchantImage && deal.merchantImageURL != nil)
	{
		if (self.dealTableView.dragging == NO && self.dealTableView.decelerating == NO)
		{
			[self startIconDownload:deal.merchantImageURL forIndexPath:indexPath];
		}
		
		cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
	}
	else
	{
		cell.imageView.image = deal.merchantImage;
	}
	
	//NSURL *url = [NSURL URLWithString:deal.merchantImageURL];
	//NSData *imageData = [NSData dataWithContentsOfURL:url];
	//cell.imageView.image = [UIImage imageWithData:imageData];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Deal *deal = [deals objectAtIndex:indexPath.row];
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithDeal:deal forCategory:category];
	[self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[RestClient requestSearchDealsFromCategoryID:[category.category_id intValue] withTerm:searchBar.text callback:self];
	[activityIndicator startAnimating];
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	[activityIndicator stopAnimating];
	[dealTableView reloadData];
	[noMatchesLabel setHidden:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if([searchText length] == 0)
		[self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar
{   
	[searchBar resignFirstResponder]; 
	[dealTableView reloadData];
	[noMatchesLabel setHidden:YES];
}



#pragma mark -
#pragma mark Table Cell Image Loader
- (void)startIconDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath
{
	IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
	if(iconDownloader == nil)
	{
		iconDownloader = [[IconDownloader alloc] init];
		iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.delegate = self;
		[imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
		[iconDownloader startDownloadWithURL:url];
		[iconDownloader release];   
	}
	
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
	if ([self.deals count] > 0)
	{
		NSArray *visiblePaths = [self.dealTableView indexPathsForVisibleRows];
		for (NSIndexPath *indexPath in visiblePaths)
		{
			Deal *deal = [deals objectAtIndex:indexPath.row];
			
			if (!deal.merchantImage) // avoid the app icon download if the app already has an icon
			{
				[self startIconDownload:deal.merchantImageURL forIndexPath:indexPath];
			}
		}
	}
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
		[self loadImagesForOnscreenRows];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self loadImagesForOnscreenRows];
}


#pragma mark - 
#pragma mark IconDownloader Delegate Methods
- (void)appImageDidLoad:(UIImage *)appImage forIndexPath:(NSIndexPath *)indexPath
{
	IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (iconDownloader != nil)
	{
		UITableViewCell *cell = [self.dealTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		
		// Display the newly loaded image
		cell.imageView.image = appImage;
		
		Deal *deal = [self.deals objectAtIndex:indexPath.row];
		deal.merchantImage = [appImage retain];
	}
}

@end
