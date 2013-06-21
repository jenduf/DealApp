//
//  Category.m
//  DealShaker
//
//  Created by Jennifer Duffey on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryVO.h"


@implementation CategoryVO
@synthesize label, category_id, type, description, parentID, deals, totalDeals;

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	
	if(self)
	{
		self.label = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"label"]];
		self.category_id = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"category_id"]];
		self.type = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"type"]];
		self.description = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"description"]];
		self.parentID = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"parent_id"]];
	}
	
	return self;
}

+ (id)createCategoryForFreeItems
{
	CategoryVO *cat = [[[self alloc] init] autorelease];
	cat.label = @"Free Deals";
	cat.category_id = @"99";
	cat.deals = [[NSMutableArray alloc] init];
	
	return cat;
}

- (void)dealloc
{
	[label release];
	[category_id release];
	[type release];
	[description release];
	[totalDeals release];
	[parentID release];
	[deals release];
	[super dealloc];
}

@end
