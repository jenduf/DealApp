//
//  Deal.h
//  DealShaker
//
//  Created by Jennifer Duffey on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Deal : NSObject 
{
	NSString *dealID, *parentID, *merchantID, *merchantName, *offerItem, *label, *type, *imageURL, *merchantImageURL, *link, *postURL;
	NSString *restrictions, *endDate, *addedDate, *primaryCategoryID, *categoryName;
	NSArray *categoryIDs;
	UIImage* merchantImage;
}

@property (nonatomic, copy) NSString *dealID, *parentID, *merchantID, *merchantName, *offerItem, *label, *type, *imageURL, *merchantImageURL, *link, *postURL;
@property (nonatomic, copy) NSString *restrictions, *endDate, *addedDate, *primaryCategoryID, *categoryName;
@property (nonatomic, copy) NSArray *categoryIDs;
@property (nonatomic, retain) UIImage *merchantImage;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)convertToDictionary;

@end
