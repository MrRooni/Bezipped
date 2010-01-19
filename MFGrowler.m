//
//  FSGrowler.m
//  Bezipped
//
//  Created by Michael Fey on 3/26/08.
//  Copyright (c) 2010, Michael Fey
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without 
//  modification, are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice, this 
//  list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice, 
//  this list of conditions and the following disclaimer in the documentation and/or 
//  other materials provided with the distribution.
//  - Neither the name of the Michael Fey nor the names of its contributors may be 
//  used to endorse or promote products derived from this software without specific 
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
//  OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//  POSSIBILITY OF SUCH DAMAGE.

#import "MFGrowler.h"

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
