//
//  DropZoneView.m
//  Add view test
//
//  Created by Michael Fey on 4/7/08.
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
