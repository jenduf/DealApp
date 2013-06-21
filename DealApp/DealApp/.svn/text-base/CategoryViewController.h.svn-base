//
//  CategoryViewController.h
//  DealShaker
//
//  Created by Jennifer Duffey on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CATEGORY_MODE		0
#define SEARCH_MODE			1

@class CategoryVO;
@interface CategoryViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
	UITableView *categoryTableView;
	UILabel *noMatchesLabel;
	
	NSArray *deals;
	
	NSMutableArray *categories;
	
	NSString *currentCategoryID;
	
	int currentCategoryIndex, mode;
	CategoryVO *currentCategory;
	
	NSMutableDictionary *categoryDictionary;
	
	UIActivityIndicatorView *activityIndicator;
	
	UISearchBar *catSearchBar;
}

@property (nonatomic, retain) NSArray *deals;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSMutableDictionary *categoryDictionary;
@property (nonatomic, retain) IBOutlet UITableView *categoryTableView;
@property (nonatomic, retain) IBOutlet UILabel *noMatchesLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UISearchBar *catSearchBar;

//- (void)parseDeals:(NSArray *)arr;
- (void)getDealByCategoryID;
- (void)onDealCountSuccess:(NSString *)count;
    
@end
