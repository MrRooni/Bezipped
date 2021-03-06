//
//  FSDropBox.m
//  Bezipped
//
//  Created by Michael Fey on 2/26/08.
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
