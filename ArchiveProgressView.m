//
//  ArchiveProgressView.m
//  Bezipped
//
//  Created by Michael Fey on 4/14/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "ArchiveProgressView.h"


@implementation ArchiveProgressView

- (id)initWithFrame:(NSRect)frame {
    if (!(self = [super initWithFrame:frame]))
		return nil;

	backgroundColor = [[[NSColor controlAlternatingRowBackgroundColors] objectAtIndex:0] retain];
	
	return self;
}

- (BOOL)isOpaque
{
	return YES;
}

- (void) setBackgroundColor:(NSColor *)color
{
	[backgroundColor release];
	backgroundColor = [color retain];
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect
{
	[backgroundColor set];
	NSRectFill([self bounds]);
}

- (void)dealloc
{
	[backgroundColor release];
	[super dealloc];
}

@end
