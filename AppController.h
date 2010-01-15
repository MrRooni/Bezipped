//
//  AppController.h
//  Bezipped
//
//  Created by Michael Fey on 10/16/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MFDropBox;
@class ArchiveProgressController;
@class MFFlippedView;
@class PreferencesController;
@class AboutBoxController;

@interface AppController : NSObject {
	MFFlippedView *progressDocumentView;
	PreferencesController *preferencesController;
	AboutBoxController *aboutBoxController;
		
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSScrollView *scrollView;
	IBOutlet MFDropBox *dropBox;
}

- (BOOL)processFiles:(NSArray *)droppedFiles;

- (IBAction)openForZipping:(id)sender;
- (IBAction)togglePreferences:(id)sender;
- (IBAction)openAboutBox:(id)sender;

@end
