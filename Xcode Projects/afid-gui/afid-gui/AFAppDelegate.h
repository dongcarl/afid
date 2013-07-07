//
//  AFAppDelegate.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
#import "AFActionDefinitionStack.h"
#import <Cocoa/Cocoa.h>

@interface AFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//MINE!!
@property (weak) IBOutlet NSTextField *incomingNumberOfGestureVectorsToRecognize;
@property (weak) IBOutlet NSTextField *incomingCorrespondingStringInput;
@property (weak) IBOutlet NSTextField *incomingBufferSize;
@property (weak) IBOutlet NSButton *submitButton;

@property (weak) IBOutlet NSTextField *incomingTrainingPath;
@property (weak) IBOutlet NSButton *loadButton;

@property (weak) IBOutlet NSTextField *incomingExportPath;
@property (weak) IBOutlet NSButton *exportButton;

@property (weak) IBOutlet NSButton *arduinoRecognizeButton;
@property (weak) IBOutlet NSTextField *incomingCurrentlySeeingText;

@property (weak) IBOutlet NSButton *belowRecognizeButton;

@property (weak) IBOutlet NSTextField *input1;
@property (weak) IBOutlet NSTextField *input2;
@property (weak) IBOutlet NSTextField *input3;
@property (weak) IBOutlet NSTextField *input4;
@property (weak) IBOutlet NSTextField *input5;
@property (weak) IBOutlet NSTextField *input6;
@property (weak) IBOutlet NSTextField *input7;
@property (weak) IBOutlet NSTextField *input8;
@property (weak) IBOutlet NSTextField *input9;
@property (weak) IBOutlet NSTextField *input10;



@property (nonatomic) AFSerialCommunicator *mainSerialCommunicator;
@property (nonatomic) AFActionDefinitionStack *mainActionDefinitionStack;

- (IBAction)saveAction:(id)sender;

- (IBAction)submitButtonPressed:(NSButton *)sender;
- (IBAction)loadButtonPressed:(id)sender;
- (IBAction)exportButtonPressed:(id)sender;
- (IBAction)startRecognitionPressed:(id)sender;
- (IBAction)recognizeFromBelowPressed:(id)sender;

@end
