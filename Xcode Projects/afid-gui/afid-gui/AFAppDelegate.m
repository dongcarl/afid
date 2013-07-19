//
//  AFAppDelegate.m
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//



#import "AFSerialCommunicator.h"

#import <Foundation/Foundation.h>

#import "AFAppDelegate.h"

@implementation AFAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize mainSerialCommunicator = _mainSerialCommunicator;
@synthesize mainActionDefinitionStack = _mainActionDefinitionStack;

-(AFSerialCommunicator *)mainSerialCommunicator
{
	if(!_mainSerialCommunicator)
	{
		_mainSerialCommunicator = [[AFSerialCommunicator alloc] initAndAutoOpenSerialPortWithBaudRate:2000000];
	}
	return _mainSerialCommunicator;
}

- (AFActionDefinitionStack *)mainActionDefinitionStack
{
	if(!_mainActionDefinitionStack)
	{
		_mainActionDefinitionStack = [[AFActionDefinitionStack alloc]init];
	}
	return _mainActionDefinitionStack;
}



//lookie here!
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "catswearingbreadhats.afid_gui" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
	return [appSupportURL URLByAppendingPathComponent:@"catswearingbreadhats.afid_gui"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
	if (_managedObjectModel) {
		return _managedObjectModel;
	}
    
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"afid_gui" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (_persistentStoreCoordinator) {
		return _persistentStoreCoordinator;
	}
    
	NSManagedObjectModel *mom = [self managedObjectModel];
	if (!mom) {
		NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
		return nil;
	}
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
	NSError *error = nil;
    
	NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
	if (!properties) {
		BOOL ok = NO;
		if ([error code] == NSFileReadNoSuchFileError) {
			ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
		}
		if (!ok) {
			[[NSApplication sharedApplication] presentError:error];
			return nil;
		}
	} else {
		if (![properties[NSURLIsDirectoryKey] boolValue]) {
			// Customize and localize this error.
			NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			[dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
			error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
			[[NSApplication sharedApplication] presentError:error];
			return nil;
		}
	}
    
	NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"afid_gui.storedata"];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
	if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
		[[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	_persistentStoreCoordinator = coordinator;
    
	return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
	if (_managedObjectContext) {
		return _managedObjectContext;
	}
    
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
		[dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
		NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
		[[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
	return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
	return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
	NSError *error = nil;
    
	if (![[self managedObjectContext] commitEditing]) {
		NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
	}
    
	if (![[self managedObjectContext] save:&error]) {
		[[NSApplication sharedApplication] presentError:error];
	}
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	// Save changes in the application's managed object context before the application terminates.
    
	if (!_managedObjectContext) {
		return NSTerminateNow;
	}
    
	if (![[self managedObjectContext] commitEditing]) {
		NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
		return NSTerminateCancel;
	}
    
	if (![[self managedObjectContext] hasChanges]) {
		return NSTerminateNow;
	}
    
	NSError *error = nil;
	if (![[self managedObjectContext] save:&error]) {
        
		// Customize this code block to include application-specific recovery steps.
		BOOL result = [sender presentError:error];
		if (result) {
			return NSTerminateCancel;
		}
        
		NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
		NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
		NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
		NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:question];
		[alert setInformativeText:info];
		[alert addButtonWithTitle:quitButton];
		[alert addButtonWithTitle:cancelButton];
        
		NSInteger answer = [alert runModal];
        
		if (answer == NSAlertAlternateReturn) {
			return NSTerminateCancel;
		}
	}
    
	return NSTerminateNow;
}


//things that matter...

- (IBAction)trainButtonPushed:(id)sender
{    
    self.mainLearner = [[AFSupervisedLearner alloc]initWithTrainingFile:[[self.incomingTrainingPath stringValue] stringByExpandingTildeInPath]
                                                     featureColumnRange:NSMakeRange([self.incomingDataRangeLocation integerValue], [self.incomingDataRangeLength integerValue])
                                                       labelColumnRange:NSMakeRange([self.incomingLabelsRangeLocation integerValue], [self.incomingLabelsRangeLength integerValue])];
    [self.mainLearner autoTune];
    [self.mainLearner train];
}

- (IBAction)predictFromArduinoButtonPushed:(id)sender
{
    NSUInteger numberToRecognize = [self.incomingArduinoNumInputs integerValue];
    
    NSUInteger numCorrect = 0;
    
    for (int i = 0; i < numberToRecognize; i++)
    {
        NSArray *currentGestureVector = [self.mainSerialCommunicator nextGestureVector];
        
        self.outgoingDimension1.stringValue = [currentGestureVector objectAtIndex:0];
        self.outgoingDimension2.stringValue = [currentGestureVector objectAtIndex:1];
        self.outgoingDimension3.stringValue = [currentGestureVector objectAtIndex:2];
        self.outgoingDimension4.stringValue = [currentGestureVector objectAtIndex:3];
        self.outgoingDimension5.stringValue = [currentGestureVector objectAtIndex:4];
        self.outgoingDimension6.stringValue = [currentGestureVector objectAtIndex:5];
        self.outgoingDimension7.stringValue = [currentGestureVector objectAtIndex:6];
        self.outgoingDimension8.stringValue = [currentGestureVector objectAtIndex:7];
        self.outgoingDimension9.stringValue = [currentGestureVector objectAtIndex:8];
        self.outgoingDimension10.stringValue = [currentGestureVector objectAtIndex:9];
        
        NSString *prediction = [self.mainLearner predictionFromGestureVector:currentGestureVector];
        self.outgoingPredictedString.stringValue = prediction;
        
        if ([self.incomingExpectedString.stringValue isEqualTo:prediction])
        {
            numCorrect++;
        }
        
        self.outgoingAccuracy.stringValue = [[NSString alloc]initWithFormat:@"%.5f%%", ((double)numCorrect*100)/(i+1)];
        
        [self.hud display];
    }
}

- (IBAction)predictFromFileButtonPushed:(id)sender
{
    
    NSString *incomingLineSeperator = [[NSString alloc] initWithFormat:@"%c", '\n'];
    NSString *incomingElementSeperator = [[NSString alloc] initWithFormat:@","];
//    NSRange defaultCorrespondingStringRange = {.location = 0, .length = 1};
//	NSRange defaultGestureVectorRange = {.location = 1, .length = 10};
    
    self.outgoingAccuracy.stringValue = [[NSString alloc]initWithFormat:@"%.5f%%", [[self.mainLearner accuracyWithARFFFile:[[self.incomingTestingPath stringValue] stringByExpandingTildeInPath]] doubleValue]*100];
        
    if ([self.incomingTestingPath.stringValue hasSuffix:@".arff"])
    {
        
        NSUInteger numCorrect = 0;
        NSError *errorReadingFromFile;
        NSStringEncoding encodingOfFile;
        NSString *incomingFile = [[NSString alloc] initWithContentsOfFile:[[self.incomingTestingPath stringValue] stringByExpandingTildeInPath]
                                                             usedEncoding:&encodingOfFile
                                                                    error:&errorReadingFromFile];
        NSArray *linesOfIncomingFile = [[[incomingFile componentsSeparatedByString:[[NSString alloc]initWithFormat:@"@DATA%c",'\n']] objectAtIndex:1] componentsSeparatedByString:incomingLineSeperator];
        
        for (int i = 0; i < linesOfIncomingFile.count; i++)
        {
            NSString *currentLine = [linesOfIncomingFile objectAtIndex:i];
            
            if ((currentLine == linesOfIncomingFile.lastObject) && ([currentLine isEqualTo:[[NSString alloc]initWithFormat:@""]]))
            {
                break;
            }
            
            NSArray *currentGestureVectorWithString = [currentLine componentsSeparatedByString:incomingElementSeperator];
            NSArray *currentGestureVector = [currentGestureVectorWithString subarrayWithRange:NSMakeRange(0, 10)];
            
            NSLog(@"%@", currentGestureVector);
            
            self.outgoingDimension1.stringValue = [currentGestureVectorWithString objectAtIndex:0];
            self.outgoingDimension2.stringValue = [currentGestureVectorWithString objectAtIndex:1];
            self.outgoingDimension3.stringValue = [currentGestureVectorWithString objectAtIndex:2];
            self.outgoingDimension4.stringValue = [currentGestureVectorWithString objectAtIndex:3];
            self.outgoingDimension5.stringValue = [currentGestureVectorWithString objectAtIndex:4];
            self.outgoingDimension6.stringValue = [currentGestureVectorWithString objectAtIndex:5];
            self.outgoingDimension7.stringValue = [currentGestureVectorWithString objectAtIndex:6];
            self.outgoingDimension8.stringValue = [currentGestureVectorWithString objectAtIndex:7];
            self.outgoingDimension9.stringValue = [currentGestureVectorWithString objectAtIndex:8];
            self.outgoingDimension10.stringValue = [currentGestureVectorWithString objectAtIndex:9];
            
            NSString *prediction = [self.mainLearner predictionFromGestureVector:currentGestureVector];
            
            self.outgoingPredictedString.stringValue = prediction;
            
            if ([[currentGestureVectorWithString objectAtIndex:10] isEqualTo:prediction])
            {
                numCorrect++;
            }
            
            self.outgoingAccuracy.stringValue = [[NSString alloc]initWithFormat:@"%.5f%%", ((double)numCorrect*100)/(i+1)];
            
            [self.hud display];
        }

    }
    else
    {
        NSUInteger numCorrect = 0;
        
        NSError *errorReadingFromFile;
        NSStringEncoding encodingOfFile;
        NSString *incomingFile = [[NSString alloc] initWithContentsOfFile:[[self.incomingTestingPath stringValue] stringByExpandingTildeInPath]
                                                             usedEncoding:&encodingOfFile
                                                                    error:&errorReadingFromFile];
        
        NSArray *linesOfIncomingFile = [[NSArray alloc] initWithArray:[incomingFile componentsSeparatedByString:incomingLineSeperator]];
        
        for (int i = 0; i < linesOfIncomingFile.count; i++)
        {
            NSString *currentLine = [linesOfIncomingFile objectAtIndex:i];
            
            if ((currentLine == linesOfIncomingFile.lastObject) && ([currentLine isEqualTo:[[NSString alloc]initWithFormat:@""]]))
            {
                break;
            }
            
            NSArray *currentGestureVector = [currentLine componentsSeparatedByString:incomingElementSeperator];
            
            self.outgoingDimension1.stringValue = [currentGestureVector objectAtIndex:0];
            self.outgoingDimension2.stringValue = [currentGestureVector objectAtIndex:1];
            self.outgoingDimension3.stringValue = [currentGestureVector objectAtIndex:2];
            self.outgoingDimension4.stringValue = [currentGestureVector objectAtIndex:3];
            self.outgoingDimension5.stringValue = [currentGestureVector objectAtIndex:4];
            self.outgoingDimension6.stringValue = [currentGestureVector objectAtIndex:5];
            self.outgoingDimension7.stringValue = [currentGestureVector objectAtIndex:6];
            self.outgoingDimension8.stringValue = [currentGestureVector objectAtIndex:7];
            self.outgoingDimension9.stringValue = [currentGestureVector objectAtIndex:8];
            self.outgoingDimension10.stringValue = [currentGestureVector objectAtIndex:9];
            
            NSString *prediction = [self.mainLearner predictionFromGestureVector:currentGestureVector];
            self.outgoingPredictedString.stringValue = prediction;
            
            if ([[currentGestureVector objectAtIndex:10] isEqualTo:prediction])
            {
                numCorrect++;
            }
            
            self.outgoingAccuracy.stringValue = [[NSString alloc]initWithFormat:@"%.5f%%", ((double)numCorrect*100)/(i+1)];
            
            [self.hud display];
        }
    }
    
}

- (IBAction)predictFromRawDataButtonPushed:(id)sender
{
    NSArray *incomingGestureVector = [[self.incomingRawData stringValue] componentsSeparatedByString:[[NSString alloc]initWithFormat:@","]];
    
    self.outgoingDimension1.stringValue = [incomingGestureVector objectAtIndex:0];
    self.outgoingDimension2.stringValue = [incomingGestureVector objectAtIndex:1];
    self.outgoingDimension3.stringValue = [incomingGestureVector objectAtIndex:2];
    self.outgoingDimension4.stringValue = [incomingGestureVector objectAtIndex:3];
    self.outgoingDimension5.stringValue = [incomingGestureVector objectAtIndex:4];
    self.outgoingDimension6.stringValue = [incomingGestureVector objectAtIndex:5];
    self.outgoingDimension7.stringValue = [incomingGestureVector objectAtIndex:6];
    self.outgoingDimension8.stringValue = [incomingGestureVector objectAtIndex:7];
    self.outgoingDimension9.stringValue = [incomingGestureVector objectAtIndex:8];
    self.outgoingDimension10.stringValue = [incomingGestureVector objectAtIndex:9];
    
    NSString *prediction = [self.mainLearner predictionFromGestureVector:incomingGestureVector];
    self.outgoingPredictedString.stringValue = prediction;
    if ([self.incomingExpectedString.stringValue isEqualTo:prediction])
    {
        self.outgoingAccuracy.stringValue = [[NSString alloc]initWithFormat:@"%.5f%%", 1.0000000];
    }
    else
    {
        self.outgoingAccuracy.stringValue = [[NSString alloc]initWithFormat:@"%.5f%%", 0.0000000];
    }    
}

@end