//
//  SearchResult.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchResult : NSObject 
{
	NSArray *offers, *deals, *coupons, *sales, *merchants;
}

@property (nonatomic, retain) NSArray *offers, *deals, *coupons, *sales, *merchants;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSArray *)parseDeals:(NSDictionary *)dealDict;

@end
