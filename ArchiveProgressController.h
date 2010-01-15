//
//  ArchiveProgressController.h
//  Bezipped
//
//  Created by Michael Fey on 3/10/08.
//  Copyright 2008 Fruit Stand Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ArchiveProgressView;

extern int BZIP_RETURN_CODE_NORMAL;
extern int BZIP_RETURN_CODE_ENVIRONMENTAL_PROBLEM;
extern int BZIP_RETURN_CODE_INTERNAL_ERROR;

@interface ArchiveProgressController : NSObject {
	NSArray *filesToArchive;
    NSTask *tarTask;
	NSString *tarFile;
	NSFileManager *fileManager;
	NSString *bezippedTempDirectory;
	NSTimer *archivePollingTimer;
	NSString *mostCommonPath;
	NSMutableArray *filePathsAfterMostCommonPath;
	AliasHandle tarFileAliasHandle;
	
	IBOutlet ArchiveProgressView *archiveProgressView;
	IBOutlet NSTextField *droppedFilesLabel;
	IBOutlet NSTextField *resultingArchiveLabel;
	IBOutlet NSTextField *archiveSizeLabel;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSImageView *droppedFilesImageView;
	IBOutlet NSButton *cancelArchiveButton;
	IBOutlet NSButton *showArchiveButton;
}

- (id)initWithFilesToArchive:(NSArray *)files;
- (void)tarTaskEnded:(NSNotification *)aNotification;
- (void)announceSuccess:(NSString *)completedFilePath;
- (void)startBuildingArchive;
- (ArchiveProgressView *)view;
- (NSNumber *)sizeOfFileSystemObjectAtPath:(NSString*)filePath;
- (void)checkTarFileSize:(NSTimer *)timer;
- (BOOL)isArchiveInProgress;
- (void)setBackgroundColor:(NSColor *)color;
- (NSString *)getArchiveDestination;
- (void)buildMostCommonPath;
- (void)buildArrayOfFilesToArchiveFromMostCommonPath;
- (void)cleanUpAfterError;

- (IBAction)stopBuildingArchive:(id)sender;
- (IBAction)revealArchiveInFinder:(id)sender;

@end
