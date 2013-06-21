
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Adds a screenshot method to UIView, 
@interface UIView (Screenshot)

// Draws the contents of this UIView to a new UIImage
- (UIImage*) screenshot;
@end
