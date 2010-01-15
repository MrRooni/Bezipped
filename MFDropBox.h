//
//  FSDropBox.h
//  Bezipped
//
//  Created by Michael Fey on 2/26/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferencesController;
@class AboutBoxController;
@class AppController;

@interface MFDropBox : NSBox {
	IBOutlet AppController *appController;
}

@end
