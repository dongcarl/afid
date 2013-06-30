//
//  AFAppDelegate.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSTextField *inputNumberTextField;
@property (weak) IBOutlet NSTextField *actionString;
@property (weak) IBOutlet NSButton *submitButton;
@property (weak) IBOutlet NSTextField *currentlySeeingText;

@property (nonatomic) AFSerialCommunicator *serialCommunicator;
@property (nonatomic) AFRecognizer *recognizer;

- (IBAction)saveAction:(id)sender;
- (IBAction)submitButtonPressed:(NSButton *)sender;
- (IBAction)startRecognitionPressed:(id)sender;

@end
