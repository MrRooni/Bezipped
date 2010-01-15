//
//  FSGrowler.m
//  Bezipped
//
//  Created by Michael Fey on 3/26/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "FSGrowler.h"

static MFGrowler* sharedGrowler = nil;

@implementation MFGrowler

+ (MFGrowler*)sharedGrowler
{
    @synchronized(self) 
	{
        if (sharedGrowler == nil)
            [[self alloc] init]; // assignment not done here
    }
    
	return sharedGrowler;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) 
	{
        if (sharedGrowler == nil) {
            sharedGrowler = [super allocWithZone:zone];
			[GrowlApplicationBridge setGrowlDelegate:sharedGrowler];
            return sharedGrowler;  // assignment and return on first allocation
        }
    }
    
	return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void) growlForArchiveCompletion:(NSString*) completedFilePath
{
	[GrowlApplicationBridge notifyWithTitle:@"Your files have been bezipped!" 
								description:[@"You can find your compressed files here: " stringByAppendingString:completedFilePath] 
						   notificationName:@"Files Bezipped" 
								   iconData:nil 
								   priority:0 
								   isSticky:NO 
							   clickContext:nil];
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (NSDictionary*) registrationDictionaryForGrowl
{
	NSArray* notifications = [NSArray arrayWithObject:@"Files Bezipped"];
	NSDictionary* registrationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:notifications, GROWL_NOTIFICATIONS_ALL, 
											notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
	return registrationDictionary;
}

@end
