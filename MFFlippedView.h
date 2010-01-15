//
//  ProgressScrollView.h
//  Bezipped
//
//  Created by Michael Fey on 3/23/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ArchiveProgressController;

@interface MFFlippedView : NSView {
	NSMutableArray* archiveProgressControllers;
}

- (BOOL) isFlipped;
- (BOOL) archivesAreInProgress;
- (void) addArchiveProgressController:(ArchiveProgressController*)archiveProgressController;
- (void) terminateAllBezippings;

@end
