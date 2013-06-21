//
//  SearchViewController.h
//  DealShaker
//
//  Created by Jennifer Duffey on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PimpViewController : UIViewController 
{
	NSMutableDictionary *selectedImages;
}

@property (nonatomic, retain) NSMutableDictionary *selectedImages;

- (IBAction)clickIcon:(id)sender;
- (void)toggleButtonsAtIndex:(int)selIndex withMin:(int)min andMax:(int)max selected:(BOOL)selected;
- (IBAction)savePig:(id)sender;
- (NSString *)getImageNameFromIndex:(int)index;

@end
