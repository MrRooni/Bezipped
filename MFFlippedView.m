//
//  ProgressScrollView
//  Bezipped
//
//  Created by Michael Fey on 3/23/08.
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
