//
//  Deal.m
//  DealShaker
//
//  Created by Jennifer Duffey on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Deal.h"


@implementation Deal
@synthesize dealID, parentID, merchantID, merchantName, offerItem, label, type, imageURL, merchantImageURL, link, postURL, merchantImage;
@synthesize restrictions, endDate, addedDate, primaryCategoryID, categoryName, categoryIDs;

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	
	if(self)
	{
		self.dealID = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"deal_id"]];
		self.parentID = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"parent_id"]];
		self.merchantID = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"merchant_id"]];
		self.merchantName = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"merchant_name"]];
		self.offerItem = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"offer_item"]];
		self.label = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"label"]];
		self.type = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"type"]];
		self.imageURL = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"image_url"]];
		self.merchantImageURL = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"merchant_image_microbar_url"]];
		self.link = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"link"]];
		self.postURL = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"wp_post_url"]];
		self.restrictions = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"restrictions"]];
		self.endDate = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"end_date"]];
		self.addedDate = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"added_date"]];
		self.primaryCategoryID = [[NSString alloc] initWithFormat:@"%@", [dict valueForKey:@"primary_category_id"]];
		
		categoryIDs = [[NSArray alloc] initWithArray:[dict objectForKey:@"category_ids"]];
	}
	
	return self;
}

- (NSDictionary *)convertToDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:self.dealID forKey:@"deal_id"];
	[dict setObject:self.merchantName forKey:@"merchant_name"];
	[dict setObject:self.label forKey:@"label"];
	[dict setObject:self.postURL forKey:@"wp_post_url"];
	
	return dict;
}

- (void)dealloc
{
	[dealID release];
	[parentID release];
	[merchantID release];
	[merchantName release];
	[offerItem release];
	[label release];
	[imageURL release];
	[merchantImageURL release];
	[link release];
	[type release];
	[merchantImage release];
	[restrictions release];
	[endDate release];
	[addedDate release];
	[primaryCategoryID release];
	[categoryName release];
	[categoryIDs release];
	[postURL release];
	[super dealloc];
}

@end
