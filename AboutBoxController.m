//
//  AboutBoxController.m
//  Bezipped
//
//  Created by Michael Fey on 5/3/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import "AboutBoxController.h"


@implementation AboutBoxController

- (id) init {
	self = [super init];
	if (!self)
		return nil;
	
	if (aboutBoxWindow == nil) {
		if (![NSBundle loadNibNamed:@"AboutBox" owner:self])
			NSLog(@"Failed to load AboutBox NIB");
		if (aboutBoxWindow == nil)
			NSLog(@"About Box Windows is still nil");
	}
	return self;
}

- (IBAction)visitFruitStandSoftwareDotCom:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fruitstandsoftware.com/bezipped"]];
}
- (NSString*)versionString
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSDictionary *infoDict = [mainBundle infoDictionary];
    
    NSString *versionString = [infoDict valueForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"Version %@", versionString];
}

- (NSWindow*)aboutBoxWindow
{
	return aboutBoxWindow;
}

@end
