//
//  Category.h
//  DealShaker
//
//  Created by Jennifer Duffey on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryVO : NSObject 
{
	NSString *label, *category_id, *type, *description, *parentID, *totalDeals;
	NSArray *deals;
}

@property (nonatomic, retain) NSString *label, *category_id, *type, *description, *parentID, *totalDeals;
@property (nonatomic, retain) NSArray *deals;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (id)createCategoryForFreeItems;

@end
