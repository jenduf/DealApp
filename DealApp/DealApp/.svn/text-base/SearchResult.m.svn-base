//
//  SearchResult.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"
#import "Deal.h"

@implementation SearchResult
@synthesize offers, deals, coupons, sales, merchants;

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	
	if(self)
	{
		NSDictionary *offersDict = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"offers"]];
		offers = [[NSArray alloc] initWithArray:[self parseDeals:offersDict]];
		
		NSDictionary *dealsDict = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"deals"]];
		deals = [[NSArray alloc] initWithArray:[self parseDeals:dealsDict]];
	}
	
	return self;
}

- (NSArray *)parseDeals:(NSDictionary *)dealDict
{
	NSArray *dataArr = [NSArray arrayWithArray:[dealDict objectForKey:@"data"]];
	NSMutableArray *returnArr = [NSMutableArray array];
	
	for(NSDictionary *dict in dataArr)
	{
		Deal *deal = [[Deal alloc] initWithDictionary:dict];
		[returnArr addObject:deal];
	}
	
	return returnArr;
}

- (void)dealloc
{
	[offers release];
	[deals release];
	[coupons release];
	[sales release];
	[merchants release];
	
	[super dealloc];
}

@end
