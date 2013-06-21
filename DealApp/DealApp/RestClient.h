//
//  RestClient.h
//  DealShaker
//
//  Created by Jennifer Duffey on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef enum
{
	STATE_READY = 0,
	STATE_ALL_CATEGORIES,
	STATE_CATEGORY,
	STATE_DEALS,
	STATE_DEAL_COUNT,
	STATE_DEALS_BY_CATEGORY,
	STATE_SEARCH_DEALS,
	STATE_EMAIL_DEAL
	
}ClientState;

typedef enum
{
	HM_NONE = 0,
	HM_GET,
	HM_POST,
	HM_DELETE
}HttpMethod;

@class CategoryVO;
@interface RestClient : NSObject 
{
	Reachability *internetReachability, *wifiReachability;
	ClientState currentState;
	
	NSObject *callbackObject;
	
	NSURLConnection *activeConnection;

	NSMutableData *responseData;
	
	NSArray *deals;
	
	int httpStatusCode;
}

@property (nonatomic, retain) NSArray *deals;

+ (RestClient *)getInstance;

+ (BOOL)checkNetworkAvailable:(BOOL)showError;

+ (BOOL)requestCategoriesWithCallback:(NSObject *)callObj;

+ (BOOL)requestDealsWithCallback:(NSObject *)callObj;

+ (BOOL)requestDealCountForCategoryID:(int)catID callback:(NSObject *)callObj;

+ (BOOL)requestCategoryByCategoryID:(int)catID callback:(NSObject *)callObj;

+ (BOOL)requestDealsByCategory:(int)catID withLimit:(int)limit callback:(NSObject *)callObj;

+ (BOOL)requestSearchDealsFromCategoryID:(int)catID withTerm:(NSString *)searchStr callback:(NSObject *)callObj;

+ (BOOL)requestEmailat:(NSString *)email forDealID:(int)dealID callback:(NSObject *)callObj;

+ (NSArray *)getDeals;


@end
