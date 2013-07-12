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
//    NSRange features = {.location = 0, .length = 10};
//    NSRange labels = {.location = 10, .length = 1};
//
//    
//    AFSupervisedLearner *learner = [[AFSupervisedLearner alloc]initWithTrainingFile:@"/Users/dongcarl/Downloads/mydata.arff"
//                                                                        testingFile:@"/Users/dongcarl/Documents/Organized/Dropbox/School/US Schooling/Choate Rosemary Hall/Junior Year/Summer/AFID/All Datasets/1/completeswapped.arff"
//                                                                 featureColumnRange:features
//                                                                   labelColumnRange:labels];
////    [learner autoTune];
//    [learner train];
//    NSLog (@"%@",[learner predictionFromGestureVector:[[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithInteger:918], //1
//                                          [[NSNumber alloc]initWithInteger:784],    //2
//                                          [[NSNumber alloc]initWithInteger:723],    //3
//                                          [[NSNumber alloc]initWithInteger:770],    //4
//                                          [[NSNumber alloc]initWithInteger:796],    //5
//                                          [[NSNumber alloc]initWithInteger:811],    //6
//                                          [[NSNumber alloc]initWithInteger:884],    //7
//                                          [[NSNumber alloc]initWithInteger:856],    //8
//                                          [[NSNumber alloc]initWithInteger:909],    //9
//                                          [[NSNumber alloc]initWithInteger:805],nil]]);    //10
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
- (IBAction)submitButtonPressed:(NSButton *)sender
{
    NSMutableString *resultingString = [[NSMutableString alloc]init];
    NSArray *incomingGestureVectors = [self.mainSerialCommunicator nextGestureVectors:[self.incomingNumberOfGestureVectorsToRecognize integerValue]];
    
    NSLog(@"%@", incomingGestureVectors);
    
    for (int i = 0; i < incomingGestureVectors.count; i++)
    {
        NSArray *currentGestureVector = [incomingGestureVectors objectAtIndex:i];
        
        [resultingString appendString:[self.incomingCorrespondingStringInput stringValue]];
        [resultingString appendString:@","];
        
        for (int i = 0; i < currentGestureVector.count; i++)
        {
            [resultingString appendString:[currentGestureVector objectAtIndex:i]];
            if (i == currentGestureVector.count-1)
            {
                [resultingString appendFormat:@"%c", '\n'];
            }
            else
            {
                [resultingString appendString:@","];
            }
        }
    }
    
    NSError *error;
    [resultingString writeToFile:[self.incomingExportPath stringValue] atomically:YES encoding:NSASCIIStringEncoding error:&error];

}

- (IBAction)loadButtonPressed:(id)sender
{
    NSRange features = {.location = 0, .length = 10};
    NSRange labels = {.location = 10, .length = 1};
//    [self.mainActionDefinitionStack trainWithStandardConfigurationsForFile:[self.incomingTrainingPath stringValue]];
    self.mainLearner = [[AFSupervisedLearner alloc]initWithTrainingFile:self.incomingTrainingPath.stringValue testingFile:@"/Users/dongcarl/Documents/Organized/Dropbox/School/US Schooling/Choate Rosemary Hall/Junior Year/Summer/AFID/All Datasets/1/completeswapped.arff" featureColumnRange:features labelColumnRange:labels];
    [self.mainLearner autoTune];
    [self.mainLearner train];
}

- (IBAction)exportButtonPressed:(id)sender
{
	[self.mainActionDefinitionStack exportCurrentActionDefinitionStackWithStandardConfigurationTo:[self.incomingExportPath stringValue]];
}

- (IBAction)startRecognitionPressed:(id)sender
{
//	NSString *recognized = [self.mainActionDefinitionStack recognizeWithBoundingboxMethod:[self.mainSerialCommunicator nextGestureVectorFromOpenedSerialPort]];
    NSString *recognized = [self.mainLearner predictionFromGestureVector:[self.mainSerialCommunicator nextGestureVector]];
	[self.incomingCurrentlySeeingText setStringValue:recognized];
}

- (IBAction)recognizeFromBelowPressed:(id)sender
{
    NSArray *incomingGestureVector = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithInteger:[self.input1 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input2 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input3 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input4 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input5 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input6 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input7 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input8 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input9 integerValue]],
                                      [[NSNumber alloc]initWithInteger:[self.input10 integerValue]],nil];
    NSString *recognizedGesture = [self.mainActionDefinitionStack recognizeWithBoundingboxMethod:incomingGestureVector];
    [self.incomingCurrentlySeeingText setStringValue:recognizedGesture];
}



@end