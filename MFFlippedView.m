//
//  ProgressScrollView
//  Bezipped
//
//  Created by Michael Fey on 3/23/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "MFFlippedView.h"
#import "ArchiveProgressController.h"
#import "ArchiveProgressView.h"

@implementation MFFlippedView

- (BOOL) archivesAreInProgress
{
	int i = 0;
	for (i; i < [archiveProgressControllers count]; i++)
		if ([[archiveProgressControllers objectAtIndex:i] isArchiveInProgress])
			return YES;
	
	return NO;
}

- (BOOL)isFlipped
{
	return YES;
}

- (void) addArchiveProgressController:(ArchiveProgressController*)archiveProgressController
{
	if (archiveProgressControllers == nil)
		archiveProgressControllers = [[NSMutableArray arrayWithCapacity:5] retain];
	[archiveProgressControllers insertObject:archiveProgressController atIndex:0];
	
	// Give the new view a background color opposite of the last one
	NSArray* backgroundColors = [NSColor controlAlternatingRowBackgroundColors];
	[archiveProgressController setBackgroundColor:[backgroundColors objectAtIndex:([archiveProgressControllers count] % [backgroundColors count])]];
	
	NSRect scrollViewRect = [self frame];
	NSRect progressControllerViewRect = [[archiveProgressController view] frame];
	
	// Since the size of the view is always changing based on how many items are in it, we
	// need to see if it's tall enough to hold the new view
	int requiredScrollViewHeight = ([[self subviews] count] + 1) * progressControllerViewRect.size.height; // Add 1 to account for the one we're adding
	if (scrollViewRect.size.height < requiredScrollViewHeight) {
		scrollViewRect.size.height += progressControllerViewRect.size.height;
		
		progressControllerViewRect.origin.y -= progressControllerViewRect.size.height;
		progressControllerViewRect.size.width = scrollViewRect.size.width;
		
		[[archiveProgressController view] setFrame:progressControllerViewRect];
		[self addSubview:[archiveProgressController view]];
		[[self animator] setFrame:scrollViewRect];
		
		// Return here if we don't need to change the size
		return;
	}
	
	progressControllerViewRect.size.width = scrollViewRect.size.width;
	
	[[archiveProgressController view] setFrame:progressControllerViewRect];
	[self addSubview:[archiveProgressController view]];
}

- (void) terminateAllBezippings
{
	int i = 0;
	for (i; i < [archiveProgressControllers count]; i++)
		[[archiveProgressControllers objectAtIndex:i] stopBuildingArchive:nil];
}

- (void)dealloc
{
	[archiveProgressControllers release];
	[super dealloc];
}
@end
