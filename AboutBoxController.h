//
//  AboutBoxController.h
//  Bezipped
//
//  Created by Michael Fey on 5/3/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AboutBoxController : NSObject {
	IBOutlet NSWindow* aboutBoxWindow;
}

- (NSWindow*)aboutBoxWindow;
- (NSString*)versionString;

- (IBAction)visitFruitStandSoftwareDotCom:(id)sender;

@end
