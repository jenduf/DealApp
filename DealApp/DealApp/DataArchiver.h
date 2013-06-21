//
//  DataArchiver.h
//  SimplyOrganic-iPad
//
//  Created by jennifer-duffey on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataArchiver : NSObject 
{
	
}

+ (NSString *)dataFilePath;

+ (id)retrieveData;
+ (void)saveData:(id)data;

@end
