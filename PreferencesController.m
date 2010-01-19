//
//  PreferencesController.m
//  Bezipped
//
//  Created by Michael Fey on 4/16/08.
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

#import "PreferencesController.h"


@implementation PreferencesController

- (id) init {
	self = [super init];
	if (!self)
		return nil;
	
	if (preferencesWindow == nil) {
		if (![NSBundle loadNibNamed:@"Preferences" owner:self])
			NSLog(@"Failed to load Preferences NIB");
		if (preferencesWindow == nil)
			NSLog(@"Preferences Windows is still nil");
	}
	return self;
}

- (void) awakeFromNib
{
	NSString* archiveLocationPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"completedArchiveLocation"];
	if ([archiveLocationPath isEqualToString:@"."]) {
		[archiveLocationPopUp selectItemAtIndex:0];
		return;
	}
	
	[archiveLocationPopUp insertItemWithTitle:[archiveLocationPath lastPathComponent] atIndex:2];
	NSSize iconSize = { 16, 16 };
	NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFile:archiveLocationPath];
	[icon setSize:iconSize];
	[[archiveLocationPopUp itemAtIndex:2] setImage:icon];
	[archiveLocationPopUp selectItemAtIndex:2];
}

- (IBAction)setToPutArchivesInTheSameFolder:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setValue:@"." forKey:@"completedArchiveLocation"];
}

- (IBAction)chooseArchiveLocation:(id)sender
{
	int result;
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
    [openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanChooseFiles:NO];
    [openPanel setTitle:@"Completed Archives Location"];
    [openPanel setDelegate:self];
    result = [openPanel runModalForDirectory:NSHomeDirectory() file:nil types:nil];
    if (result == NSOKButton) {
		[[NSUserDefaults standardUserDefaults] setValue:[openPanel filename] forKey:@"completedArchiveLocation"];
		
		NSString* archiveLocationPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"completedArchiveLocation"];
		if ([archiveLocationPopUp numberOfItems] == 4)
			[archiveLocationPopUp removeItemAtIndex:2];
		[archiveLocationPopUp insertItemWithTitle:[archiveLocationPath lastPathComponent] atIndex:2];
		NSSize iconSize = { 16, 16 };
		NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFile:archiveLocationPath];
		[icon setSize:iconSize];
		[[archiveLocationPopUp itemAtIndex:2] setImage:icon];
		[archiveLocationPopUp selectItemAtIndex:2];
	} else {
		NSString* archiveLocationPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"completedArchiveLocation"];
		if ([archiveLocationPath isEqualToString:@"."]) {
			[archiveLocationPopUp selectItemAtIndex:0];
			if ([archiveLocationPopUp numberOfItems] == 4)
				[archiveLocationPopUp removeItemAtIndex:2];
		} else {
			[archiveLocationPopUp selectItemAtIndex:2];
		}
	}
}

- (NSWindow*)preferencesWindow
{
	return preferencesWindow;
}

@end
