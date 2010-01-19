//
//  ArchiveProgressController.h
//  Bezipped
//
//  Created by Michael Fey on 3/10/08.
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
