//
//  PimpIcon.m
//  DealShaker
//
//  Created by Jennifer Duffey on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PimpIcon.h"


@implementation PimpIcon
@synthesize imageName, rowIndex, selectedIndex;

+ (id)pimpIconWithName:(NSString *)name row:(NSString *)row andSelectedIndex:(NSString *)selIndex
{
	PimpIcon *pimpIcon = [[[self alloc] init] autorelease];
	pimpIcon.imageName = name;
	pimpIcon.rowIndex = row;
	pimpIcon.selectedIndex = selIndex;
	
	return pimpIcon;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:imageName forKey:@"imageName"];
	[encoder encodeObject:rowIndex forKey:@"rowIndex"];
	[encoder encodeObject:selectedIndex forKey:@"selectedIndex"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	
	if(self)
	{
		self.imageName = [decoder decodeObjectForKey:@"imageName"];
		self.rowIndex = [decoder decodeObjectForKey:@"rowIndex"];
		self.selectedIndex = [decoder decodeObjectForKey:@"selectedIndex"];
	}
	
	return self;
}


- (void)dealloc
{
	[imageName release];
	[rowIndex release];
	[selectedIndex release];
	[super dealloc];
}

@end
