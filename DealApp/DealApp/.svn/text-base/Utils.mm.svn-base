//
//  Utils.m
//  DealShaker
//
//  Created by Jennifer Duffey on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "RegexKitLite.h"

@implementation Utils

+ (NSString *)getDateStringFromTimeInterval:(NSString *)str
{
	NSString *returnStr;
	
	int dateInt = [str intValue];
	if(dateInt == 0)
		returnStr = @"No Expiration Date";
	else
	{
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		returnStr = [formatter stringFromDate:date];
		[formatter release];
	}
	
	return returnStr;
}

+ (BOOL)validateEmailAddress:(NSString *)email
{
	if(email != nil)
	{
		NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
		//	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		
		return [email isMatchedByRegex:emailRegex];
		
		//	if((email.length > 6)) //&& [email isMatchedByRegex:emailRegEx])
		//	return YES;
	}
	
	return NO;
}

@end
