//
//  SecondViewController.h
//  DealShaker
//
//  Created by Jennifer Duffey on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@class CategoryVO;
@interface DealViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, IconDownloaderDelegate, UIScrollViewDelegate>
{
	NSArray *deals;
	UITableView *dealTableView;
	UILabel *noMatchesLabel;
	
	int catID;
	
	CategoryVO *category;
	
	NSMutableDictionary *imageDownloadsInProgress;
	
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) NSArray *deals;
@property (nonatomic, retain) CategoryVO *category;
@property (nonatomic, retain) IBOutlet UITableView *dealTableView;
@property (nonatomic, retain) IBOutlet UILabel *noMatchesLabel;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (id)initWithCategory:(CategoryVO *)cat;
- (void)startIconDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath;

@end
