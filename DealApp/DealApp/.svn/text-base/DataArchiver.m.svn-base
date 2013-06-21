//
//  DataArchiver.m
//  SimplyOrganic-iPad
//
//  Created by jennifer-duffey on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataArchiver.h"

@implementation DataArchiver

+ (id)retrieveData
{
	
	NSObject *archivedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataFilePath]];
	
	return archivedObject;
}

+ (void)saveData:(id)data
{	
	
	NSString *filePath = [self dataFilePath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if([fileManager fileExistsAtPath:filePath])
	{
		NSLog(@"File exists");
	}
	
	[NSKeyedArchiver archiveRootObject:data toFile:filePath];
}

+ (NSString *)dataFilePath
{
	NSString *fileName = @"archive.plist";
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
	
	return [cachesDirectory stringByAppendingPathComponent:fileName];
}

@end
