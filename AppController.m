//
//  AppController.m
//  Bezipped
//
//  Created by Michael Fey on 10/16/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "AppController.h"
#import "MFDropBox.h"
#import "ArchiveProgressController.h"
#import "MFFlippedView.h"
#import "PreferencesController.h"
#import "AboutBoxController.h"

@implementation AppController

+ (void)initialize
{
	NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
	
	[standardDefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
										@".", @"completedArchiveLocation",
										[NSNumber numberWithBool:YES], @"createWindowsFriendlyArchives",
										[NSNumber numberWithBool:YES], @"useGrowl",
										nil]];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *bezippedTempDirectory = @"";
	
	NSArray *applicationSupportDirectories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if ([applicationSupportDirectories count] == 0)	
		bezippedTempDirectory = [@"~/.bezippedTemp" stringByExpandingTildeInPath];
	else
		bezippedTempDirectory = [[applicationSupportDirectories objectAtIndex:0] stringByAppendingPathComponent:@"Bezipped/Temp"];
	
	if ([fileManager fileExistsAtPath:bezippedTempDirectory] == NO)
		return;
	
	[fileManager removeItemAtPath:bezippedTempDirectory	error:nil];
}

- (void)awakeFromNib
{
	[mainWindow setShowsResizeIndicator:NO];
}

- (BOOL)processFiles:(NSArray*)droppedFiles {
	if ([droppedFiles count] <= 0)
		return NO;
	
	if ([scrollView isHidden]) {
		// Setup the resizing masks to show the scroll view 
		[dropBox setAutoresizingMask:NSViewWidthSizable | NSViewMinYMargin ];
		[scrollView setAutoresizingMask:NSViewWidthSizable | NSViewMinYMargin];
		
		// Get the necessary space for the scroll view
		float progressAreaHeight = [scrollView bounds].size.height;
		progressAreaHeight += 16;
		
		NSRect windowFrameRect = [mainWindow frame];
		windowFrameRect.size.height += progressAreaHeight;
		windowFrameRect.origin.y -= progressAreaHeight;
		
		// Animate the resize of the window and unhide the scroll view and clear button.
		[mainWindow setFrame:windowFrameRect display:YES animate:YES];
		[[scrollView animator] setHidden:NO];
		
		// Give the window a new minimum and maximum size.
		NSSize minimumSize = [mainWindow contentMinSize];
		minimumSize.height = [[mainWindow contentView] bounds].size.height;
		NSSize maximumSize = {FLT_MAX, FLT_MAX};
		[mainWindow setContentMinSize:minimumSize];
		[mainWindow setContentMaxSize:maximumSize];
		[mainWindow setShowsResizeIndicator:YES];
		
		// Reset the resizing masks
		[scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	}
	
	// Create an ArchiveProgressController
	ArchiveProgressController* archiveProgressController = [[ArchiveProgressController alloc] initWithFilesToArchive:droppedFiles];
	
	if (progressDocumentView == nil) {
		// Create an NSRect the same width as the scroll view and height as the progress controller view
		NSRect progressViewRect = [scrollView frame];
		progressViewRect.size.width = [scrollView contentSize].width;
		progressViewRect.size.height = [scrollView contentSize].height - 1;
		
		// Create the view to hold the ArchiveProgressControllers
		progressDocumentView = [[MFFlippedView alloc] initWithFrame:progressViewRect];
		[progressDocumentView setAutoresizingMask:NSViewWidthSizable | NSViewMinXMargin];
		// Set the view as the documentView of the archiveProgressSrcollView
		[scrollView setDocumentView:progressDocumentView];
		[scrollView setHasVerticalScroller:YES];
	}
	
	[progressDocumentView addArchiveProgressController:archiveProgressController];
	[archiveProgressController startBuildingArchive];
	[archiveProgressController release];
	
	return YES;
}

#pragma mark NSApplication delegate methods

//Called when the files are dragged to the application, whether it's running or not
- (void)application:(NSApplication *)sender openFiles:(NSArray *)droppedFiles
{
	if (![mainWindow isVisible])
		[mainWindow orderFront:self];
	
	[self processFiles:droppedFiles];
	[sender replyToOpenOrPrint:NSApplicationDelegateReplySuccess];
}

// Relaunches the main window if it has been closed.
- (BOOL)applicationShouldHandleReopen:(NSApplication *)app hasVisibleWindows:(BOOL)visible
{
	if (visible)
		return TRUE;
	[mainWindow orderFront:self];
	return FALSE;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	if (![progressDocumentView archivesAreInProgress])
		return NSTerminateNow;
	
	int alertReturn = NSRunAlertPanel(@"Are you sure you want to quit?", @"There are still files being bezipped, quit anyway?", @"Quit", @"Don't Quit", nil);
	if (alertReturn == NSAlertAlternateReturn)
		return NSTerminateCancel;
	
	[progressDocumentView terminateAllBezippings];
    return NSTerminateNow;
}

#pragma mark IBActions

- (IBAction)openForZipping:(id)sender
{
	int result;
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
    [openPanel setAllowsMultipleSelection:YES];
	[openPanel setCanChooseDirectories:YES];
    [openPanel setTitle:@"Bezip"];
    [openPanel setDelegate:self];
    result = [openPanel runModalForDirectory:NSHomeDirectory() file:nil types:nil];
    if (result == NSOKButton)
		[self processFiles:[openPanel filenames]];
}

- (IBAction)togglePreferences:(id)sender
{
	if (preferencesController == nil)
		preferencesController = [[PreferencesController alloc] init];
	if ([[preferencesController preferencesWindow] isKeyWindow])
		[[preferencesController preferencesWindow] orderOut:sender];
	else
		[[preferencesController preferencesWindow] makeKeyAndOrderFront:self];
}

- (IBAction)openAboutBox:(id)sender
{
	if (aboutBoxController == nil)
		aboutBoxController = [[AboutBoxController alloc] init];
	[[aboutBoxController aboutBoxWindow] makeKeyAndOrderFront:self];
}

@end
