//
//  DropZoneView.m
//  Add view test
//
//  Created by Michael Fey on 4/7/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "MFDropZoneView.h"
#import "AJHBezierUtils.h"


@implementation MFDropZoneView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(NSRect)rect {
	// Draw the round rectangle
	NSRect viewRect = [self bounds];
	viewRect.size.width -= 8;
	viewRect.size.height -= 8;
	viewRect.origin.x += 4;
	viewRect.origin.y += 4;
	NSBezierPath *roundRectPath = [NSBezierPath bezierPathWithRoundRect:viewRect xRadius:20 yRadius:20];
	
	float lineDashArray[2];
	lineDashArray[0] = 12.0; // segment painted with stroke color
	lineDashArray[1] = 8.0;  // segment not painted with a color
	[roundRectPath setLineDash:lineDashArray count:1 phase:1];
	[roundRectPath setLineCapStyle:NSRoundLineCapStyle];
	
	[[NSColor lightGrayColor] set]; // stroke color
	
	[roundRectPath setLineWidth:2.0];
	[roundRectPath stroke];

	// Draw the stem of the arrow
	float width = viewRect.size.width;
	float height = viewRect.size.height;

	NSBezierPath* stemPath;
	stemPath = [NSBezierPath bezierPath];
	[stemPath moveToPoint:NSMakePoint (width/2 + 4, height - 20)];
	[stemPath lineToPoint:NSMakePoint (width/2 + 4, 35)];
	[stemPath setLineWidth:15.0];
	[stemPath stroke];

	// Draw the head of the arrow
	float arrowSize = 50;
    float arrowAngle = 40;
	
	// The arrow head eclipses the end of the line, so it needs its own line separate from the stem to look good.
	NSBezierPath* arrowPath = [NSBezierPath bezierPath];
	[arrowPath moveToPoint:NSMakePoint (width/2 + 4, 55)];
	[arrowPath lineToPoint:NSMakePoint (width/2 + 4, 25)];
	[arrowPath setLineWidth:2.0];
	
	NSBezierPath* arrowHead = [arrowPath bezierPathWithArrowHeadForEndOfLength:arrowSize angle:arrowAngle];
	[arrowHead closePath];
	[arrowHead fill];
	[arrowHead stroke];
}

@end
