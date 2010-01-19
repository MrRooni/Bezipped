//
//  ArchiveProgressController.m
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

#import "ArchiveProgressController.h"
#import "MFGrowler.h"

int BZIP_RETURN_CODE_NORMAL = 0;
int BZIP_RETURN_CODE_ENVIRONMENTAL_PROBLEM = 1;
int BZIP_RETURN_CODE_INTERNAL_ERROR = 2;

@implementation ArchiveProgressController

#pragma mark Initialization

- (id) initWithFilesToArchive:(NSArray*)files 
{
	if (![self init])
		return nil;
	
	filesToArchive = [files retain];
	fileManager = [[NSFileManager defaultManager] retain];
	
	NSArray* applicationSupportDirectories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if ([applicationSupportDirectories count] == 0)	
		bezippedTempDirectory = [@"~/.bezippedTemp" stringByExpandingTildeInPath];
	
	bezippedTempDirectory = [[applicationSupportDirectories objectAtIndex:0] stringByAppendingPathComponent:@"Bezipped/Temp"];
	
	if ([fileManager fileExistsAtPath:bezippedTempDirectory] == NO)
		[fileManager createDirectoryAtPath:bezippedTempDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	
	return self;
}

- (id) init 
{
	if (!(self = [super init]))
		return nil;
	
	if (archiveProgressView == nil) {
		if (![NSBundle loadNibNamed:@"ArchiveProgressView" owner:self])
			NSLog(@"Failed to load ArchiveProgressView");
		if (archiveProgressView == nil)
			NSLog(@"archiveProgressView is still nil");
	}

	return self;
}

#pragma mark Setters and getters

- (ArchiveProgressView *) view 
{
	return archiveProgressView;
}

- (BOOL) isArchiveInProgress
{
	return [tarTask isRunning];
}

- (void) setBackgroundColor:(NSColor*)color
{
	[archiveProgressView setBackgroundColor:color];
}

#pragma mark Start and Stop

- (void) startBuildingArchive
{
	NSMutableArray* fileNames = [NSMutableArray arrayWithCapacity:[filesToArchive count]];
	NSString* fileNamesLabelText = @"";
	double sizeOfAllDraggedFiles = 0;

	int i = 0;
	for (i; i < [filesToArchive count]; i++) {
		[fileNames addObject:[[filesToArchive objectAtIndex:i] lastPathComponent]];
		fileNamesLabelText = [fileNamesLabelText stringByAppendingString:[fileNames objectAtIndex:i]];
		sizeOfAllDraggedFiles += [[self sizeOfFileSystemObjectAtPath:[filesToArchive objectAtIndex:i]] doubleValue];
		
		if (i != [filesToArchive count] - 1)
			fileNamesLabelText = [fileNamesLabelText stringByAppendingString:@", "];
	}
	
	[progressIndicator setMaxValue:sizeOfAllDraggedFiles];
	[progressIndicator setDoubleValue:0];
	[droppedFilesLabel setStringValue:fileNamesLabelText];
	[droppedFilesImageView setImage:[[NSWorkspace sharedWorkspace] iconForFile:[filesToArchive objectAtIndex:0]]];
	[archiveSizeLabel setStringValue:@"0 KB"];
	
	NSString* tarFileName;
	if (i == 1)
		tarFileName = [[fileNames objectAtIndex:0] stringByAppendingPathExtension:@"tbz.XXXX"];
	else
		tarFileName = [@"Bezipped Archive" stringByAppendingPathExtension:@"tbz.XXXX"];
	
	NSString* tempFileTemplate = [bezippedTempDirectory stringByAppendingPathComponent:tarFileName];
	char* tempFilePath = mktemp((char *)([fileManager fileSystemRepresentationWithPath:tempFileTemplate]));
	tarFile = [[fileManager stringWithFileSystemRepresentation:tempFilePath length:strlen(tempFilePath)] retain];
	
	[self buildMostCommonPath];
	[self buildArrayOfFilesToArchiveFromMostCommonPath];
	NSMutableArray* tarArguments = [NSMutableArray arrayWithObjects:@"-cjf", tarFile, nil];
	[tarArguments addObjectsFromArray:filePathsAfterMostCommonPath];
	
	tarTask = [[[NSTask alloc] init] retain];
	[tarTask setLaunchPath:@"/usr/bin/tar"];

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"createWindowsFriendlyArchives"])
		[tarTask setEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"COPYFILE_DISABLE", nil]];
	
	// Run the task from the indicated directory
	[tarTask setCurrentDirectoryPath:mostCommonPath];
	[tarTask setArguments:tarArguments];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tarTaskEnded:) name:NSTaskDidTerminateNotification object:tarTask];
	archivePollingTimer = [[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(checkTarFileSize:) userInfo:nil repeats:YES] retain];

	[tarTask launch];
}

-(IBAction) stopBuildingArchive:(id)sender
{
	[tarTask terminate];
}

#pragma mark Utility methods

- (void)checkTarFileSize:(NSTimer*)timer
{
	double tarFileSize = [[self sizeOfFileSystemObjectAtPath:tarFile] doubleValue];
	[progressIndicator setDoubleValue:tarFileSize];
	
	float tarFileSizeFloat = tarFileSize / 1024;
	
	NSString* postFix = @" KB";
	if (tarFileSizeFloat > 1024) {
		tarFileSizeFloat = tarFileSizeFloat / 1024;
		postFix = @" MB";
	}
	[archiveSizeLabel setStringValue:[[NSString stringWithFormat:@"Archive size: %1.1f", tarFileSizeFloat] stringByAppendingString:postFix]];
}

- (NSNumber*) sizeOfFileSystemObjectAtPath:(NSString*)filePath
{
	NSArray* contents;
	unsigned long long size = 0;
	NSEnumerator* enumerator;
	NSString* path;
	BOOL isDirectory;
	
	// Determine Paths to Add
	if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory)
		contents = [fileManager subpathsAtPath:filePath];
	else
		contents = [NSArray arrayWithObject:@""];

	// Add Size Of All Paths
	enumerator = [contents objectEnumerator];
	while (path = [enumerator nextObject]) {
		NSDictionary *fattrs = [fileManager fileAttributesAtPath:[filePath stringByAppendingPathComponent:path] traverseLink:NO];
		size += [[fattrs objectForKey:NSFileSize] unsignedLongLongValue];
	}

	// Return Total Size in Bytes
	return [NSNumber numberWithUnsignedLongLong:size];
}

- (IBAction) revealArchiveInFinder:(id)sender {
	if (tarFileAliasHandle == NULL)
		[[NSWorkspace sharedWorkspace] selectFile:tarFile inFileViewerRootedAtPath:nil];
	
	FSRef tarFileTarget;
	Boolean wasChanged = false;
	OSErr err = FSResolveAlias(NULL, tarFileAliasHandle, &tarFileTarget, &wasChanged);
	if (err == fnfErr)
		NSLog(@"There was a problem resolving the alias for %@", tarFile);
	
	CFURLRef tarFileURL = CFURLCreateFromFSRef( kCFAllocatorDefault, &tarFileTarget );
	NSString* path = [(NSURL *)tarFileURL path];
	CFRelease(tarFileURL);
	
	[[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];
}

- (void)buildArrayOfFilesToArchiveFromMostCommonPath
{
	if (filePathsAfterMostCommonPath != nil)
		[filePathsAfterMostCommonPath release];
	
	filePathsAfterMostCommonPath = [NSMutableArray arrayWithCapacity:[filesToArchive count]];
	
	int additionalFromIndexPosition = 1;
	if ([mostCommonPath isEqualToString:@"/"])
		additionalFromIndexPosition = 0;
		
	int i = 0;
	for (i; i < [filesToArchive count]; i++) {
		[filePathsAfterMostCommonPath addObject:[[filesToArchive objectAtIndex:i] substringFromIndex:[mostCommonPath length] + additionalFromIndexPosition]];
		NSLog(@"File: %@", [filePathsAfterMostCommonPath objectAtIndex:i]);
	}
}

- (void)buildMostCommonPath
{
	if (mostCommonPath != nil)
		[mostCommonPath release];
	
	mostCommonPath = [[filesToArchive objectAtIndex:0] stringByDeletingLastPathComponent];
	int i = 1;
	for (i; i < [filesToArchive count]; i++) {
		if ([mostCommonPath isEqualToString:[[filesToArchive objectAtIndex:i] stringByDeletingLastPathComponent]])
			continue;
		
		NSArray* commonPathTokens = [mostCommonPath pathComponents];
		NSArray* fileToArchivePathTokens = [[filesToArchive objectAtIndex:i] pathComponents];
		
		int j = 1;
		mostCommonPath = @"/";
		int minLength = [commonPathTokens count];
		if (minLength > [fileToArchivePathTokens count])
			minLength = [fileToArchivePathTokens count];
		
		for (j; j < minLength; j++) {
			if (![[commonPathTokens objectAtIndex:j] isEqualToString:[fileToArchivePathTokens objectAtIndex:j]])
				break;
			
			mostCommonPath = [mostCommonPath stringByAppendingPathComponent:[commonPathTokens objectAtIndex:j]];
		}
	}
}

- (NSString*)getArchiveDestination
{
	NSString* archiveDestination = [[NSUserDefaults standardUserDefaults] stringForKey:@"completedArchiveLocation"];
	
	// An archive destination of "." means that the user wants the archive to go in the same directory as the files being dragged.
	if (![archiveDestination isEqualToString:@"."])
		return archiveDestination;
	
	return mostCommonPath;
}

- (void)cleanUpAfterError
{
	[archivePollingTimer invalidate];
	[archivePollingTimer release];
	
	[progressIndicator setHidden:YES];
	[resultingArchiveLabel setStringValue:@"Cancelled"];
	[resultingArchiveLabel setHidden:NO];
	
	[archiveSizeLabel setHidden:YES];
	[cancelArchiveButton setHidden:YES];
	[showArchiveButton setHidden:YES];
	
	[fileManager removeItemAtPath:tarFile error:nil];
}


#pragma mark Successful creation methods

- (void)tarTaskEnded:(NSNotification *)aNotification
{
	if (![tarTask isRunning]) {
		int status = [tarTask terminationStatus];
		if (status != BZIP_RETURN_CODE_NORMAL) {
			[self cleanUpAfterError];
			return;
		}
	}
	
	[archivePollingTimer invalidate];
	[archivePollingTimer release];

	NSString* bezippedDestination = [self getArchiveDestination];
	NSString* bezippedFileLocation = [bezippedDestination stringByAppendingPathComponent:[[tarFile lastPathComponent] stringByDeletingPathExtension]];

	// Check the size of the archive one more time to update the size label with the actual size of the archive.
	[self checkTarFileSize:nil];
	
	// Determine an available file name for the completed archive
	NSString *nextAvailableFileName = bezippedFileLocation; 
	if ([fileManager fileExistsAtPath:bezippedFileLocation] == YES) {
		int sequenceNumber = 2;
		do { 
			nextAvailableFileName = [NSString stringWithFormat:[[[bezippedFileLocation lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@" %d.%@"], sequenceNumber, [bezippedFileLocation pathExtension]]; 
			nextAvailableFileName = [[bezippedFileLocation stringByDeletingLastPathComponent] stringByAppendingPathComponent:nextAvailableFileName]; 
			sequenceNumber++; 
		} while ([fileManager fileExistsAtPath:nextAvailableFileName]);
	}
	// Move the archive from the temp location to the "completed" location
	NSError *error = nil;
	BOOL success = [fileManager moveItemAtPath:tarFile toPath:nextAvailableFileName error:&error];
	if (!success) {
		[NSApp presentError:error];
		[progressIndicator setHidden:YES];
		[resultingArchiveLabel setStringValue:[error localizedDescription]];
		[resultingArchiveLabel setHidden:NO];
		
		[archiveSizeLabel setHidden:YES];
		[cancelArchiveButton setHidden:YES];
		[showArchiveButton setHidden:YES];
		
		[fileManager removeItemAtPath:tarFile error:nil];
		return;
	}
	
	// Update the GUI
	[droppedFilesImageView setImage:[[NSWorkspace sharedWorkspace] iconForFile:nextAvailableFileName]];
	[[progressIndicator animator] setDoubleValue:[progressIndicator maxValue]];
	[[progressIndicator animator] setHidden:YES];
	[resultingArchiveLabel setStringValue:[nextAvailableFileName lastPathComponent]];
	[[resultingArchiveLabel animator] setHidden:NO];

	[cancelArchiveButton setHidden:YES];
	[showArchiveButton setHidden:NO];

	// Change the tarFile name to the resulting file name for use in revealing the location of the archive.
	tarFile = [nextAvailableFileName retain];
	tarFileAliasHandle = NULL;
	OSErr err = FSNewAliasFromPath(NULL, [nextAvailableFileName UTF8String], 0, &tarFileAliasHandle, false);
	if (err != noErr)
		NSLog(@"There was a problem creating the alias for file %@", nextAvailableFileName);
	
	
	// Announce success!
	[self announceSuccess:bezippedFileLocation];
}

- (void)announceSuccess:(NSString*)completedFilePath
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"useGrowl"])
		[[MFGrowler sharedGrowler] growlForArchiveCompletion:completedFilePath];
}

#pragma mark Dealloc

- (void)dealloc
{
	[fileManager release];
	[tarFile release];
    [super dealloc];
}

@end
