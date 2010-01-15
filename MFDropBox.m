//
//  FSDropBox.m
//  Bezipped
//
//  Created by Michael Fey on 2/26/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "MFDropBox.h"
#import "AppController.h"

@implementation MFDropBox

- (id)initWithCoder:(NSCoder *) coder {
    if (!(self = [super initWithCoder:coder]))
		return nil;

	[self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];

    return self;
}

#pragma mark Drag n' Drop Protocol Methods

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	if((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
		[[self animator] setFillColor:[NSColor darkGrayColor]];
		return NSDragOperationCopy;
	} else
		return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSPasteboard *pasteboard = [sender draggingPasteboard];
	return [appController processFiles:[pasteboard propertyListForType:NSFilenamesPboardType]];
}

#pragma mark Instance deconstruction

- (void)dealloc
{
	[self unregisterDraggedTypes];
    [super dealloc];
}

@end
