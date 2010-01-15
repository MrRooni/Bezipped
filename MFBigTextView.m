//
//  FSBigTextView.m
//  Bezipped
//
//  Created by Michael Fey on 4/13/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "MFBigTextView.h"


@implementation MFBigTextView

- (void)drawRect:(NSRect)rect {
    NSDictionary *stringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
								[NSFont fontWithName:@"Lucida Grande Bold" size:20.0f], NSFontAttributeName,
								[NSColor lightGrayColor], NSForegroundColorAttributeName, nil];
    NSAttributedString *dragFilesHereString = [[NSAttributedString alloc] 
									initWithString:@"Drag Files Here"
									attributes: stringAttributes];

	NSRect stringRect = [self bounds];
	stringRect.size.width = [dragFilesHereString size].width;
	stringRect.size.height = [dragFilesHereString size].height;
	stringRect.origin.x = ([self bounds].size.width / 2) - (stringRect.size.width / 2);

	[dragFilesHereString drawInRect:stringRect];
	[dragFilesHereString release];
	[stringAttributes release];
}

@end
