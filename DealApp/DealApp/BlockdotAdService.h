
#import <Foundation/Foundation.h>

typedef enum {
	None,
	Data,
	Image
} DownloadType;

@class BlockdotAdService;

@protocol BlockdotAdServiceDelegate
- (void)adDownloaded: (BlockdotAdService*) ad;
@end

@interface BlockdotAdService : NSObject {
	
	NSString* link;
	UIImage* image;
	
	BOOL isDownloading;
	BOOL downloaded;
	BOOL available;
	
	// Retained while downloading
	NSObject<BlockdotAdServiceDelegate>* delegate;
	DownloadType downloadType;
	NSMutableData* currentData;
	NSMutableString* currentString;
	NSString* currentElement;
	NSURL* imageURL;
}

+ (BlockdotAdService*) sharedInstance;

/** Starts an asynchronous download of the ad link and image. If the ad is already downloaded, 
 this method notifies the delegate immediately and returns.
 The delegate is retained while downloading and released after notification.
 The delegate can be nil (useful for pre-loading).
 */
- (void) startDownloadWithGameID: (int) gameID 
					  platformID: (int) platformID 
						 version: (int) version 
						  sizeID: (int) sizeID
				   orientationID: (int) orientationID
						delegate: (NSObject<BlockdotAdServiceDelegate>*) del;

/** Returns YES if an ad and its image has successfully downloaded. */
@property (readonly, nonatomic) BOOL available;

/** Returns the ad link (the URL to open when the user touches the ad image). If the ad
 is not yes downloaded, returns nil. */
@property (readonly, nonatomic) NSString* link;

/** Returns the ad image. If the ad is not yes downloaded, returns nil. */
@property (readonly, nonatomic) UIImage* image;

@end
