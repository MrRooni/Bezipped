//
//  PreferencesController.m
//  Bezipped
//
//  Created by Michael Fey on 4/16/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

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
