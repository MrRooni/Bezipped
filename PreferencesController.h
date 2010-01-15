//
//  PreferencesController.h
//  Bezipped
//
//  Created by Michael Fey on 4/16/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSObject {
	IBOutlet NSWindow* preferencesWindow;
	IBOutlet NSPopUpButton* archiveLocationPopUp;
}

- (NSWindow*)preferencesWindow;
- (IBAction)setToPutArchivesInTheSameFolder:(id)sender;
- (IBAction)chooseArchiveLocation:(id)sender;

@end
