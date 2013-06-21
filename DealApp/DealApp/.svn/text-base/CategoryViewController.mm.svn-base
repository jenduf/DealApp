//
//  CategoryViewController.m
//  DealShaker
//
//  Created by Jennifer Duffey on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryVO.h"
#import "DealViewController.h"
#import "RestClient.h"
#import "Deal.h"
#import "DetailViewController.h"
#import "SearchResult.h"
#import "Constants.h"

@implementation CategoryViewController
@synthesize categoryTableView, categories, deals, categoryDictionary, activityIndicator, catSearchBar, noMatchesLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[categories release];
	[deals release];
	[categoryTableView release];
	[categoryDictionary release];
	[activityIndicator release];
	[catSearchBar release];
	[noMatchesLabel release];
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
	
	[FlurryAnalytics logEvent:FLURRY_DEALS];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[catSearchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	currentCategoryIndex = 0;
	mode = CATEGORY_MODE;
	
	[activityIndicator startAnimating];
	
	[RestClient requestCategoriesWithCallback:self];
}

- (void)getDealByCategoryID
{	
	currentCategoryID = [[NSString alloc] initWithFormat:@"%@", [[categoryDictionary allKeys] objectAtIndex:currentCategoryIndex]];
	//[RestClient requestDealsByCategory:[currentCategoryID intValue] withLimit:100 callback:self];
	//[RestClient requestDealCountForCategoryID:[currentCategoryID intValue] callback:self];
	[self onDealCountSuccess:@"1"];
}

- (void)onCategorySuccess:(NSArray *)arr
{
	categoryDictionary = [[NSMutableDictionary alloc] initWithCapacity:[arr count]];
	categories = [[NSMutableArray alloc] initWithCapacity:[arr count]];
	
	for(CategoryVO *cat in arr)
	{
		[categoryDictionary setObject:cat forKey:cat.category_id];
		NSLog(@"Category Name: %@, Category ID: %@", cat.label, cat.category_id);
	}
	
	CategoryVO *freeCat = (CategoryVO *)[CategoryVO createCategoryForFreeItems];
	[categoryDictionary setObject:freeCat forKey:freeCat.category_id];
	
	[self.categoryTableView reloadData];

	[self getDealByCategoryID];
	
	/*NSArray *allDeals = [NSArray arrayWithArray:[RestClient getDeals]];
	
	if(allDeals == nil)
		[RestClient requestDealsByCategory:99 withLimit:0 callback:self];
	else
		[self parseDeals:allDeals];*/
}

- (void)onCategoryError
{
	NSLog(@"Category Retrieval Error");
	[activityIndicator stopAnimating];
}

- (void)onDealSearchSuccess:(SearchResult *)result
{
	[activityIndicator stopAnimating];
	
	deals = [[NSArray alloc] initWithArray:result.deals];
	
	if(result.deals == nil || [result.deals count] == 0)
	{
		[noMatchesLabel setHidden:NO];
	}
	
	[categoryTableView reloadData];
}

- (void)onDealSearchError
{
	NSLog(@"Deals Search Error");
	[activityIndicator stopAnimating];
}


- (void)onDealCountSuccess:(NSString *)count
{
	CategoryVO *catVO = (CategoryVO *)[categoryDictionary objectForKey:currentCategoryID];
	catVO.totalDeals = count;
	
	if([count intValue] > 0)
		[categories addObject:catVO];
	
	[currentCategoryID release];
	
	currentCategoryIndex++;
	
	if(currentCategoryIndex < [[categoryDictionary allKeys] count])
	{
		[self getDealByCategoryID];
	}
	else
	{
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"label" ascending:YES];
		[categories sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[activityIndicator stopAnimating];
		[self.categoryTableView reloadData];
	}
	
	
	//CategoryVO *cat = (CategoryVO *)[categories objectAtIndex:currentCategoryIndex];
	//cat.total_items = [count intValue];
	
	//currentCategoryIndex++;
	
//	if(currentCategoryIndex >= [categories count])
//		[categoryTableView reloadData];
//	else
//		[self getCategoryCounts];
}

- (void)onDealCountError
{
	NSLog(@"Deal Count Error");
}

/*
- (void)parseDeals:(NSArray *)arr
{
	NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[categoryDictionary count]];
	
	for(Deal *deal in arr)
	{
		if([deal.categoryIDs count] > 1)
		{
			for(NSString *str in deal.categoryIDs)
			{
				CategoryVO *cat = (CategoryVO *)[categoryDictionary objectForKey:str];
				
				if(cat != nil && ![cat.category_id isEqualToString:FREE_DEAL_CATEGORY_ID])
				{
					[cat.deals addObject:deal];
					
					if([tempArray indexOfObjectIdenticalTo:cat] == NSNotFound)
					{
						[tempArray addObject:cat];
					}
				}
			}
		}
		else
		{
			CategoryVO *cat = (CategoryVO *)[categoryDictionary objectForKey:FREE_DEAL_CATEGORY_ID];
			[cat.deals addObject:deal];
		}
	}
	
	CategoryVO *freeCat = (CategoryVO *)[categoryDictionary objectForKey:FREE_DEAL_CATEGORY_ID];
	[tempArray addObject:freeCat];
	
	categories = [[NSArray alloc] initWithArray:tempArray];
	
	[self.categoryTableView reloadData];
}
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.deals = nil;
	self.categories = nil;
	self.categoryTableView = nil;
	self.categoryDictionary = nil;
	self.activityIndicator = nil;
	self.catSearchBar = nil;
	self.noMatchesLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if(mode == SEARCH_MODE)
		return [deals count];
	
	return [categories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
		cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
		cell.textLabel.textColor = [UIColor grayColor];
	}
	
	// Set up the cell...
	if(mode == CATEGORY_MODE)
	{
		CategoryVO *cat = (CategoryVO *)[categories objectAtIndex:indexPath.row];
		//cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", cat.label, cat.totalDeals];
		cell.textLabel.text = [NSString stringWithFormat:@"%@", cat.label];
		//cell.detailTextLabel.text = deal.label;
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"cat_%@_icon", cat.category_id]];
		cell.tag = [cat.category_id intValue];
	}
	else
	{
		Deal *deal = [deals objectAtIndex:indexPath.row];
		cell.textLabel.text = deal.merchantName;
		cell.detailTextLabel.text = deal.label;
		cell.imageView.image = deal.merchantImage;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	CategoryVO *cat = (CategoryVO *)[categories objectAtIndex:indexPath.row];
	
	if(mode == CATEGORY_MODE)
	{	
		DealViewController *dealViewController = [[DealViewController alloc] initWithCategory:cat];
		[self.navigationController pushViewController:dealViewController animated:YES];
	}
	else
	{
		Deal *deal = [deals objectAtIndex:indexPath.row];
		DetailViewController *detailViewController = [[DetailViewController alloc] initWithDeal:deal forCategory:cat];
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	mode = SEARCH_MODE;
	[RestClient requestSearchDealsFromCategoryID:0 withTerm:searchBar.text callback:self];
	[activityIndicator startAnimating];
	[searchBar resignFirstResponder];
	
	[FlurryAnalytics logEvent:FLURRY_SEARCH];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	mode = CATEGORY_MODE;
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	[activityIndicator stopAnimating];
	[categoryTableView reloadData];
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
	mode = CATEGORY_MODE;
	[searchBar resignFirstResponder];
	[activityIndicator stopAnimating];
	[categoryTableView reloadData];
	[noMatchesLabel setHidden:YES];
}

@end
