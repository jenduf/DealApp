//
//  PimpIcon.h
//  DealShaker
//
//  Created by Jennifer Duffey on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PimpIcon : NSObject 
{
	NSString *imageName, *rowIndex, *selectedIndex;
}

@property (nonatomic, retain) NSString *imageName, *rowIndex, *selectedIndex;

+ (id)pimpIconWithName:(NSString *)name row:(NSString *)row andSelectedIndex:(NSString *)selIndex;

@end
