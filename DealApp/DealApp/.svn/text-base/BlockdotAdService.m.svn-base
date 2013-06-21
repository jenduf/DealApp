
#import "BlockdotAdService.h"

//#define LOG_AD_SERVICE

// http://www.blockdot.com/mobile/mobileAdService.aspx?gameID=1&platformID=1&version=1&sizeID=1&orientationID=1
static NSString* urlFormat = @"http://www.blockdot.com/mobile/mobileAdService.aspx?gameID=%i&platformID=%i&version=%i&sizeID=%i&orientationID=%i";

@interface BlockdotAdService (Private)
- (void) finish;
- (void) parseXML: (NSData*) data;
@end

@implementation BlockdotAdService

@synthesize available, link, image;

- (void) startDownloadWithGameID: (int) gameID 
					  platformID: (int) platformID 
						 version: (int) version 
						  sizeID: (int) sizeID
				   orientationID: (int) orientationID
						delegate: (NSObject<BlockdotAdServiceDelegate>*) del {
	if (delegate != nil) {
		[delegate release];
	}		
	delegate = [del retain];
	if (isDownloading) {
		return;
	}
	else if (downloaded) {
		[self finish];
	}
	else {
		isDownloading = YES;
		downloadType = Data;
		
		NSURL* url = [NSURL URLWithString: [NSString stringWithFormat: urlFormat, 
											 gameID, platformID, version, sizeID, orientationID]];
		
		NSURLRequest* urlRequest = [NSURLRequest requestWithURL: url];
		
		NSURLConnection* urlConnection = [NSURLConnection connectionWithRequest: urlRequest 
																	   delegate: self];
		[urlConnection start];

#ifdef LOG_AD_SERVICE
		NSLog(@"BlockdotAdService: Downloading xml from %@", [url absoluteURL]);
#endif
	}
}

- (void) finish {
	isDownloading = NO;
	available = (link != nil && image != nil);
#ifdef LOG_AD_SERVICE
	NSLog(@"BlockdotAdService: Finished downloading (%@)", available ? @"Ad Found" : @"No Ad Found");
#endif	
	if (delegate != nil) {
		[delegate adDownloaded: self];
		[delegate release];
		delegate = nil;		
		downloadType = None;
	}
	if (imageURL != nil) {
		[imageURL release];
		imageURL = nil;
	}
}
			  
// URLConnection Delegate methods

- (void) connection: (NSURLConnection*) connection didReceiveResponse: (NSURLResponse*) response {
	if (currentData != nil) {
		[currentData release];
		currentData = nil;
	}
	currentData = [[NSMutableData alloc] init];
}
 
- (void) connection: (NSURLConnection*)connection didReceiveData: (NSData*) data {
	[currentData appendData: data];
}
 
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
#ifdef LOG_AD_SERVICE
	NSLog(@"BlockdotAdService: Download error: %@", [error localizedDescription]);
#endif	
	[currentData release];
	currentData = nil;
	if (downloadType != None) {
		downloadType = None;
		[self finish];
	}
}
 
 - (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	 if (downloadType == Data) {
		 // Parse XML
		 [self parseXML: currentData];
		 if (imageURL != nil && link != nil) {
			 downloadType = Image;
			 NSURLRequest* urlRequest = [NSURLRequest requestWithURL: imageURL];
			 
			 NSURLConnection* urlConnection = [NSURLConnection connectionWithRequest: urlRequest 
																			delegate: self];
			 [urlConnection start];
		 }
		 else {
			 [self finish];
		 }
	 }
	 else if (downloadType == Image) {
#ifdef LOG_AD_SERVICE
		 NSLog(@"BlockdotAdService: Parsing Image");
#endif	
		 UIImage* parsedImage = [UIImage imageWithData: currentData];
		 if (parsedImage != nil) {
			 image = [parsedImage retain];
		 }
		 else {
			 NSLog(@"Couldn't load image: %@", imageURL);
		 }
		 [imageURL release];
		 imageURL = nil;
		 [self finish];
	 }
	 [currentData release];
	 currentData = nil;
}

// XML parsing
/*
 <ads>
 
 <ad adid='1'>
 <adImage>http://blockdot.com/assets/images/yahooMap.png</adImage>
 <adLink>http://blockdot.com/iphone/chicktionary.aspx</adLink>
 </ad>
 
 </ads>
 
 
 <messages>
 
 <message messageid='1'>      
 <messageText>Enjoy your Ads!</adLink>
 </message>
 
 </messages>
 */
- (void) parseXML: (NSData*) data {
#ifdef LOG_AD_SERVICE
	NSLog(@"BlockdotAdService: Parsing XML");
#endif
	
	// Clean up bad XML.
	//	<?xml version="1.0" encoding="UTF-8"?> 
	NSString* bad  = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>";
	NSString* good = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
	NSString* string = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
	string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	string = [string stringByReplacingOccurrencesOfString: bad withString: good];
	data = [string dataUsingEncoding: NSUTF8StringEncoding];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData: data];
	[parser setDelegate: self];
	[parser setShouldProcessNamespaces: NO];
	[parser setShouldReportNamespacePrefixes: NO];
	[parser setShouldResolveExternalEntities: NO];
	[parser parse];
	downloaded = YES;
}
			  
- (void) parser: (NSXMLParser*) parser didStartElement: (NSString*) elementName 
			  namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qName
			  attributes: (NSDictionary*) attributeDict {
	
	if (qName) {
		elementName = qName;
	}
	
#ifdef LOG_AD_SERVICE
	NSLog(@"BlockdotAdService: Parsing element: %@", elementName);
#endif		

	if (currentElement != nil) {
		[currentElement release];
		currentElement = nil;
	}
	currentElement = [elementName copy];
	
	if (currentString != nil) {
		[currentString release];
		currentString = nil;
	}
	currentString = [[NSMutableString alloc] initWithCapacity: 100];
	
}

- (void) parser: (NSXMLParser*) parser didEndElement: (NSString*) elementName 
   namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qName {
	
	NSString* string = [currentString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([@"adImage" isEqualToString: currentElement]) {
		imageURL = [[NSURL alloc] initWithString: string];
	}
	else if ([@"adLink" isEqualToString: currentElement]) {
		link = [string retain];
	}
	
	[currentString release];
	currentString = nil;
	[currentElement release];
	currentElement = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (currentString != nil) {
		[currentString appendString: string];
	}
}

- (void) parser: (NSXMLParser*) parser parseErrorOccurred: (NSError*) parseError{
#ifdef LOG_AD_SERVICE
	NSLog(@"Error on XML Parse: %@", [parseError localizedDescription]);
#endif
}			  
			  
// Singleton pattern
// http://developer.apple.com/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/chapter_3_section_10.html#//apple_ref/doc/uid/TP40002974-CH4-SW32

static BlockdotAdService* sharedInstance = nil;

+ (BlockdotAdService*) sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedInstance;
}

+ (id) allocWithZone: (NSZone*) zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id) copyWithZone: (NSZone*) zone {
    return self;
}

- (id) retain {
    return self;
}

- (unsigned) retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void) release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
