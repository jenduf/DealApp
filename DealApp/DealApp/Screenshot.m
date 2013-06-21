
#import "Screenshot.h"


@implementation UIView (Screenshot)

- (UIImage*) screenshot 
{
	UIGraphicsBeginImageContext(self.layer.visibleRect.size);
	[self.layer renderInContext: UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end
