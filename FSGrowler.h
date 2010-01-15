//
//  FSGrowler.h
//  Bezipped
//
//  Created by Michael Fey on 3/26/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@interface MFGrowler : NSObject <GrowlApplicationBridgeDelegate> {
}

+ (MFGrowler*) sharedGrowler;

- (void) growlForArchiveCompletion:(NSString*) completedFilePath;

// Growl delegate methods
- (NSDictionary*) registrationDictionaryForGrowl;

@end
