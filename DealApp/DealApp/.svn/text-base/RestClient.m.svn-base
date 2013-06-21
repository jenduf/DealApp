//
//  RestClient.m
//  DealShaker
//
//  Created by Jennifer Duffey on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RestClient.h"
#import "JSON.h"
#import "Constants.h"
#import "Deal.h"
#import "CategoryVO.h"
#import "SearchResult.h"

@interface RestClient (Private) 

- (BOOL)networkAvailable:(BOOL)showError;

- (void)startRequest:(NSString *)reqStr method:(HttpMethod)method;

- (BOOL)issueRequestCategoriesWithCallback:(NSObject *)callObj;
- (BOOL)issueRequestDealsWithCallback:(NSObject *)callObj;
- (BOOL)issueRequestDealsByCategory:(int)catID withLimit:(int)limit callback:(NSObject *)callObj;
- (BOOL)issueRequestDealCountForCategoryID:(int)catID callback:(NSObject *)callObj;
- (BOOL)issueRequestCategoryByCategoryID:(int)catID callback:(NSObject *)callObj;
- (BOOL)issueRequestSearchDealsFromCategoryID:(int)catID withTerm:(NSString *)searchStr callback:(NSObject *)callObj;
- (BOOL)issueRequestSendEmail:(NSString *)email forDealID:(int)dealID callback:(NSObject *)callObj;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (void)clearAndIssueCallback:(SEL)successSel successObj:(id)successObj errorSel:(SEL)errorSel;
- (void)clearAndIssueCallback:(SEL)successSel successObj:(id)successObj errorSel:(SEL)errorSel errorObj:(id)errorObj;

@end

static RestClient *restInstance = nil;

@implementation RestClient
@synthesize deals;

+ (RestClient *)getInstance
{
	@synchronized([RestClient class])
	{
		if(restInstance == nil)
		{
			restInstance = [[[RestClient alloc] init] retain];
		}
	}
	
	return restInstance;
}

- (id)init
{
	self = [super init];
	
	if(self)
	{
		responseData = [[NSMutableData data] retain];
		
		deals = nil;
		
		internetReachability = [[Reachability reachabilityForInternetConnection] retain];
		wifiReachability = [[Reachability reachabilityForLocalWiFi] retain];
		[internetReachability startNotifer];
		[wifiReachability startNotifer];
	}
	
	return self;
}

- (void)dealloc
{
	[deals release];
	[super dealloc];
}

#pragma mark -
#pragma mark Check Network Availability
+ (BOOL)checkNetworkAvailable:(BOOL)showError
{
	return [[RestClient getInstance] networkAvailable:showError];
}

- (BOOL)networkAvailable:(BOOL)showError
{
	BOOL internet = NO;
	BOOL wifi = NO;
	
	if ( internetReachability != nil )
	{
		internet = ( [internetReachability currentReachabilityStatus] != NotReachable );
	}
	
	if ( !internet && ( wifiReachability != nil ) )
	{
		wifi = ( [wifiReachability currentReachabilityStatus] != NotReachable );
	}
	
	if ( ( !internet && !wifi ) && showError )
	{
		//Not connected
		NSString* title = NSLocalizedString( @"No Internet Connection", @"InternetErr" );
		NSString* msg = NSLocalizedString( @"This device is not connected to the internet. Some features will not work.", @"NotConnErr" );
		
		UIAlertView* alert = nil;
		
		alert = [[UIAlertView alloc]
			    initWithTitle:title
			    message:msg
			    delegate:nil
			    cancelButtonTitle:NSLocalizedString( @"OK", @"OK" )
			    otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}
	
	return ( internet || wifi );
}

- (void)startRequest:(NSString *)reqStr method:(HttpMethod)method
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqStr]];
	
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	switch(method)
	{
		case HM_GET:
			[request setHTTPMethod:@"GET"];
			break;
		case HM_POST:
			[request setHTTPMethod:@"POST"];
			break;
		case HM_DELETE:
			[request setHTTPMethod:@"DELETE"];
			break;
		case HM_NONE:
			break;
	}
	
	httpStatusCode = NO_STATUS_SET;
	
	activeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark Category Request
+ (BOOL)requestCategoriesWithCallback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestCategoriesWithCallback:callObj];
}

- (BOOL)issueRequestCategoriesWithCallback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_ALL_CATEGORIES;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onCategoryError)];
			return NO;
		}
		
		NSString *reqStr = [NSString stringWithFormat:@"%@category/?status=active", REST_URL];
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)handleCategoryResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	NSMutableArray *categories;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Category Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		if(results != nil)
		{
			NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:[results objectForKey:@"result"]];
			NSArray *dataArray = [NSArray arrayWithArray:[resultDict objectForKey:@"data"]];
			
			categories = [NSMutableArray array];
			
			for(NSDictionary *dict in dataArray)
			{
				CategoryVO *cat = [[CategoryVO alloc] initWithDictionary:dict];
				if([cat.parentID intValue] == 0)
					[categories addObject:cat];
			}
			
			successSel = @selector(onCategorySuccess:);
		}
		
		[jsonParser release];
	}
	
	if(successSel == nil)
	{
		errorSel = @selector(onCategoryError);
	}
	
	[self clearAndIssueCallback:successSel successObj:categories errorSel:errorSel];
	
}

#pragma mark -
#pragma mark Category by ID
+ (BOOL)requestCategoryByCategoryID:(int)catID callback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestCategoryByCategoryID:catID callback:callObj];
}

- (BOOL)issueRequestCategoryByCategoryID:(int)catID callback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_CATEGORY;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onCategoryByIDError)];
			return NO;
		}
		
		NSString *reqStr = [NSString stringWithFormat:@"%@category/?category_id[]=%i", REST_URL, catID];
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)handleCategoryByCategoryIDResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	CategoryVO *cat = nil;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Category Item Count Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		if(results != nil)
		{
			NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:[results objectForKey:@"result"]];
			NSArray *dataArray = [NSArray arrayWithArray:[resultDict objectForKey:@"data"]];
			
			if([dataArray count] > 0)
				cat = [[CategoryVO alloc] initWithDictionary:[dataArray objectAtIndex:0]];
			
			successSel = @selector(onCategoryByIDSuccess:);
		}
		
		[jsonParser release];
	}
	
	if(successSel == nil)
	{
		errorSel = @selector(onCategoryByIDError);
	}
	
	[self clearAndIssueCallback:successSel successObj:cat errorSel:errorSel];
	
}

#pragma mark -
#pragma mark Deal Count By Category
+ (BOOL)requestDealCountForCategoryID:(int)catID callback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestDealCountForCategoryID:catID callback:callObj];
}

- (BOOL)issueRequestDealCountForCategoryID:(int)catID callback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_DEAL_COUNT;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onDealCountError)];
			return NO;
		}
		
		NSString *catString;
		
		if(catID == 0)
			catString = @"category_id[]=99";
		else
			catString = [NSString stringWithFormat:@"category_id[]=%i", catID];
		
		NSString *reqStr = [NSString stringWithFormat:@"%@deal/?limit=0&%@&select[]=deal_id&status=active", REST_URL, catString];
		
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)handleDealCountForCategoryIDResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	NSString *totalCount;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Deals Count Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		if(results != nil)
		{
			NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:[results objectForKey:@"result"]];
			totalCount = [NSString stringWithFormat:@"%@", [resultDict valueForKey:@"total"]];
			
			successSel = @selector(onDealCountSuccess:);
		}
		
		[jsonParser release];
	}
	
	if(successSel == nil)
	{
		errorSel = @selector(onDealCountError);
	}
	
	[self clearAndIssueCallback:successSel successObj:totalCount errorSel:errorSel];
	
}

#pragma mark -
#pragma mark Deals
+ (BOOL)requestDealsWithCallback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestDealsWithCallback:callObj];
}

- (BOOL)issueRequestDealsWithCallback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_DEALS;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onDealsError)];
			return NO;
		}
		
		NSString *reqStr = [NSString stringWithFormat:@"%@deal/?limit=50&status=active", REST_URL];
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)handleDealsResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Deals Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		[deals release];
		deals = nil;
		
		if(results != nil)
		{
			NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:[results objectForKey:@"result"]];
			NSArray *dataArray = [NSArray arrayWithArray:[resultDict objectForKey:@"data"]];
			
			NSMutableArray *temp = [NSMutableArray array];
			
			for(NSDictionary *dict in dataArray)
			{
				Deal *deal = [[Deal alloc] initWithDictionary:dict];
				
				[temp addObject:deal];
			}
			
			deals = [[NSArray alloc] initWithArray:temp];
			
			successSel = @selector(onDealsSuccess:);
		}
		
		[jsonParser release];
	}
	
	if(successSel == nil)
	{
		errorSel = @selector(onDealsError);
	}
	
	[self clearAndIssueCallback:successSel successObj:deals errorSel:errorSel];
	
}

#pragma mark -
#pragma mark Deals By Category
+ (BOOL)requestDealsByCategory:(int)catID withLimit:(int)limit callback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestDealsByCategory:catID withLimit:limit callback:callObj];
}

- (BOOL)issueRequestDealsByCategory:(int)catID withLimit:(int)limit callback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_DEALS_BY_CATEGORY;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onDealsByCategoryError)];
			return NO;
		}
		
		NSString *catString;
		
		if(catID == 0)
			catString = @"";
		else
			catString = [NSString stringWithFormat:@"&category_id[]=%i", catID];
		
		NSString *reqStr = [NSString stringWithFormat:@"%@deal/?limit=%i%@&status=active", REST_URL, limit, catString];
		
#ifdef ALLOW_DEBUG_OUTPUT
		NSLog(@"Deals By Category Request: %@", reqStr);
#endif
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

+ (NSArray *)getDeals
{
	return [restInstance deals];
}

- (void)handleDealsByCategoryResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Deals By Category Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		[deals release];
		deals = nil;
		
		if(results != nil)
		{
			NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:[results objectForKey:@"result"]];
			NSArray *dataArray = [NSArray arrayWithArray:[resultDict objectForKey:@"data"]];
			
			NSMutableArray *temp = [NSMutableArray array];
			
			for(NSDictionary *dict in dataArray)
			{
				Deal *deal = [[Deal alloc] initWithDictionary:dict];
				
				[temp addObject:deal];
			}
			
			deals = [[NSArray alloc] initWithArray:temp];
			
			successSel = @selector(onDealsByCategorySuccess:);
		}
		
		[jsonParser release];
	}

	if(successSel == nil)
	{
		errorSel = @selector(onDealsByCategoryError);
	}
	
	[self clearAndIssueCallback:successSel successObj:deals errorSel:errorSel];
	
}

#pragma mark -
#pragma mark Email Deals
+ (BOOL)requestEmailat:(NSString *)email forDealID:(int)dealID callback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestSendEmail:email forDealID:dealID callback:callObj];
}

- (BOOL)issueRequestSendEmail:(NSString *)email forDealID:(int)dealID callback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_EMAIL_DEAL;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onEmailDealsError)];
			return NO;
		}
		
		NSString *reqStr = [NSString stringWithFormat:@"%@emailalert/senddealemail/%@/%i", REST_URL, email, dealID];
		
#ifdef ALLOW_DEBUG_OUTPUT
		NSLog(@"Email Deal Request: %@", reqStr);
#endif
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)handleEmailDealResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	NSString *message;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Email Deal Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		if(results != nil)
		{
			//NSNumber *resultNumber = [NSNumber numberWithBool:[[results valueForKey:@"status"] boolValue]];
			message = [[NSString alloc] initWithFormat:@"%@", [results objectForKey:@"message"]];
			
			successSel = @selector(onEmailDealsSuccess:);
		}
		
		[jsonParser release];
	}
	
	if(successSel == nil)
	{
		errorSel = @selector(onEmailDealsError);
	}
	
	[self clearAndIssueCallback:successSel successObj:message errorSel:errorSel];
	
}

/*
#pragma mark -
#pragma mark Deals By Category
+ (BOOL)requestSearchDealsFromCategoryID:(int)catID withTerm:(NSString *)searchStr callback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestSearchDealsFromCategoryID:catID withTerm:searchStr callback:callObj];
}

- (BOOL)issueRequestSearchDealsFromCategoryID:(int)catID withTerm:(NSString *)searchStr callback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_SEARCH_DEALS;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onDealSearchError)];
			return NO;
		}
		
		searchStr = [NSString stringWithFormat:@"\\<%@\\>", searchStr];
		
		CFStringRef formattedSearchStr = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)searchStr, NULL, CFSTR("!/#$%&\'[]{}()*+-,-.|:;<>=@^_`~"), kCFStringEncodingUTF8);
		
		NSString *reqStr = [NSString stringWithFormat:@"%@deal/?limit=100&category_id[]=%i&name[]=%@&status=active", REST_URL, catID, formattedSearchStr];
		
		
#ifdef ALLOW_DEBUG_OUTPUT
		NSLog(@"Deals Search Request: %@", reqStr);
#endif
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)handleSearchRequestResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	NSMutableArray *deals;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Deals Search Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		if(results != nil)
		{
			NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:[results objectForKey:@"result"]];
			NSArray *dataArray = [NSArray arrayWithArray:[resultDict objectForKey:@"data"]];
			
			deals = [NSMutableArray array];
			
			for(NSDictionary *dict in dataArray)
			{
				Deal *deal = [[Deal alloc] initWithDictionary:dict];
				[deals addObject:deal];
			}
			
			successSel = @selector(onDealSearchSuccess:);
		}
		
		[jsonParser release];
	}
	
	if(successSel == nil)
	{
		errorSel = @selector(onDealSearchError);
	}
	
	[self clearAndIssueCallback:successSel successObj:deals errorSel:errorSel];
	
}*/

#pragma mark -
#pragma mark Deals By Category
+ (BOOL)requestSearchDealsFromCategoryID:(int)catID withTerm:(NSString *)searchStr callback:(NSObject *)callObj
{
	return [[RestClient getInstance] issueRequestSearchDealsFromCategoryID:catID withTerm:searchStr callback:callObj];
}

- (BOOL)issueRequestSearchDealsFromCategoryID:(int)catID withTerm:(NSString *)searchStr callback:(NSObject *)callObj
{
	if(currentState == STATE_READY)
	{
		currentState = STATE_SEARCH_DEALS;
		callbackObject = callObj;
		
		if(![self networkAvailable:YES])
		{
			[self clearAndIssueCallback:nil successObj:nil errorSel:@selector(onDealSearchError)];
			return NO;
		}
		
		NSString *reqStr = [NSString stringWithFormat:@"%@search/?s=%@&limit=100", REST_URL, searchStr];
		
		
#ifdef ALLOW_DEBUG_OUTPUT
		NSLog(@"Deals Search Request: %@", reqStr);
#endif
		
		[self startRequest:reqStr method:HM_GET];
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)handleSearchRequestResponse:(NSString *)responseStr
{
	SEL errorSel = nil;
	SEL successSel = nil;
	NSError *error = nil;
	SearchResult *searchResult;
	
#ifdef ALLOW_DEBUG_OUTPUT
	NSLog(@"Deals Search Response: %@", responseStr);
#endif
	
	if((httpStatusCode == NO_STATUS_SET) || (httpStatusCode == 200))
	{
		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSDictionary *results = [jsonParser objectWithString:responseStr error:&error];
		
		if(results != nil)
		{
			NSDictionary *resultDict = [	NSDictionary dictionaryWithDictionary:[results objectForKey:@"result"]];
			NSDictionary *dataDict = [NSDictionary dictionaryWithDictionary:[resultDict objectForKey:@"data"]];
			
			searchResult = [[SearchResult alloc] initWithDictionary:dataDict];
			
			successSel = @selector(onDealSearchSuccess:);
		}
		
		[jsonParser release];
	}
	
	if(successSel == nil)
	{
		errorSel = @selector(onDealSearchError);
	}
	
	[self clearAndIssueCallback:successSel successObj:searchResult errorSel:errorSel];
	
}

- (void)clearAndIssueCallback:(SEL)successSel successObj:(id)successObj errorSel:(SEL)errorSel
{
	[self clearAndIssueCallback:successSel successObj:successObj errorSel:errorSel errorObj:nil];
}

- (void)clearAndIssueCallback:(SEL)successSel successObj:(id)successObj errorSel:(SEL)errorSel errorObj:(id)errorObj
{
	currentState = STATE_READY;
	
	//Inform the caller of success or failure
	if ( callbackObject != nil )
	{
		NSObject* tmp = callbackObject;	//Use a tmp since the callback might set a new target obj.
		callbackObject = nil;
		
		if ( errorSel != nil )
		{
			if ( errorObj != nil )
				[tmp performSelector:errorSel withObject:errorObj];
			else
				[tmp performSelector:errorSel];
		}
		else if ( successSel != nil )
		{
			if ( successObj != nil )
				[tmp performSelector:successSel withObject:successObj];
			else
				[tmp performSelector:successSel];
		}
	}
}

#pragma mark -
#pragma mark Handle URLRequest
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	NSDictionary *responseHeader = nil;
	
	responseData.length = 0;
	
	if([response respondsToSelector:@selector(allHeaderFields)])
	{
		responseHeader = [NSDictionary dictionaryWithDictionary:[((NSHTTPURLResponse *)response) allHeaderFields]];
		
#ifdef ALLOW_DEBUG_OUTPUT
		// Log all headers in response
		NSArray *keys = [responseHeader allKeys];
		for(NSString *key in keys)
		{
			NSLog(@"%@", key);
		}
#endif
		
	}
	
	if([response respondsToSelector:@selector(statusCode)])
		httpStatusCode = [((NSHTTPURLResponse *)response) statusCode];
	else
		httpStatusCode = NO_STATUS_SET;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error localizedDescription]);
	httpStatusCode = INTERNAL_STATUS_ERROR;
	[self connectionDidFinishLoading:connection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	activeConnection = nil;
	
	switch(currentState)
	{
		case STATE_ALL_CATEGORIES:
			[self handleCategoryResponse:responseStr];
			break;
			
		case STATE_CATEGORY:
			[self handleCategoryByCategoryIDResponse:responseStr];
			break;
			
		case STATE_DEALS:
			[self handleDealsResponse:responseStr];
			break;
			
		case STATE_DEAL_COUNT:
			[self handleDealCountForCategoryIDResponse:responseStr];
			break;
			
		case STATE_DEALS_BY_CATEGORY:
			[self handleDealsByCategoryResponse:responseStr];
			break;
			
		case STATE_SEARCH_DEALS:
			[self handleSearchRequestResponse:responseStr];
			break;
			
		case STATE_EMAIL_DEAL:
			[self handleEmailDealResponse:responseStr];
			break;
			
		case STATE_READY:
			break;
	}
}

@end
