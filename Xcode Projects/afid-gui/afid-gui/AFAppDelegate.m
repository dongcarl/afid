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
    NSArray *arrayOfAlphabet = [[NSArray alloc]initWithObjects:@"A",
                                @"B",
                                @"C",
                                @"D",
                                @"E",
                                @"F",
                                @"G",
                                @"H",
                                @"I",
                                @"K",
                                @"L",
                                @"M",
                                @"N",
                                @"O",
                                @"P",
                                @"Q",
                                @"R",
                                @"S",
                                @"T",
                                @"U",
                                @"V",
                                @"W",
                                @"X",
                                @"Y",nil];
    for (
    

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
- (IBAction)startButtonPressed:(id)sender
{
    NSDate *start = [NSDate date];
    NSMutableString *resultingString = [[NSMutableString alloc]init];    
    
    for (int i = 0; i < [self.incomingNumberOfGestureVectorsToRecognize integerValue]; i++)
    {
        
        
        NSArray *currentGestureVector = [self.mainSerialCommunicator nextGestureVector];
        NSLog(@"reading: %@", currentGestureVector);
        
        [resultingString appendString:[self.incomingCorrespondingStringInput stringValue]];
        [resultingString appendString:@","];
        
        for (int i = 0; i < currentGestureVector.count; i++)
        {
            
            switch (i) {
                case 0:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input1.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 1:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input2.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 2:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input3.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 3:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input4.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 4:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input5.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 5:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input6.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 6:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input7.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 7:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input8.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 8:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input9.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
                    
                case 9:
                    [resultingString appendString:[currentGestureVector objectAtIndex:i]];
                    self.input10.stringValue = [currentGestureVector objectAtIndex:i];
                    break;
            }
            
            if (i == currentGestureVector.count-1)
            {
                [resultingString appendFormat:@"%c", '\n'];
            }
            else
            {
                [resultingString appendString:@","];
            }
        }
        self.incomingRemainingGestures.integerValue = self.incomingNumberOfGestureVectorsToRecognize.integerValue - i - 1;
        self.incomingTimeElapsed.stringValue = stringFromInterval(-[start timeIntervalSinceNow]);
        [self.window display];
    }

    NSError *error;
    [resultingString writeToFile:[self.incomingExportPath stringValue] atomically:YES encoding:NSASCIIStringEncoding error:&error];

}

NSString *stringFromInterval(NSTimeInterval timeInterval)
{
#define SECONDS_PER_MINUTE (60)
#define MINUTES_PER_HOUR (60)
#define SECONDS_PER_HOUR (SECONDS_PER_MINUTE * MINUTES_PER_HOUR)
#define HOURS_PER_DAY (24)
    
    // convert the time to an integer, as we don't need double precision, and we do need to use the modulous operator
    int ti = round(timeInterval);
    
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", (ti / SECONDS_PER_HOUR) % HOURS_PER_DAY, (ti / SECONDS_PER_MINUTE) % MINUTES_PER_HOUR, ti % SECONDS_PER_MINUTE];
    
#undef SECONDS_PER_MINUTE
#undef MINUTES_PER_HOUR
#undef SECONDS_PER_HOUR
#undef HOURS_PER_DAY
}



@end