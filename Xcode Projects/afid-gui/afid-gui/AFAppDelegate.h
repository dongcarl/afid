//
//  AFAppDelegate.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
#import "AFSupervisedLearner.h"
#import "AFActionDefinitionStack.h"
#import <Cocoa/Cocoa.h>

@interface AFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *hud;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//MINE!!
@property (weak) IBOutlet NSTextField *incomingDataRangeLocation;
@property (weak) IBOutlet NSTextField *incomingDataRangeLength;
@property (weak) IBOutlet NSTextField *incomingLabelsRangeLocation;
@property (weak) IBOutlet NSTextField *incomingLabelsRangeLength;


@property (weak) IBOutlet NSTextField *incomingTrainingPath;
@property (weak) IBOutlet NSTextField *incomingExpectedString;
@property (weak) IBOutlet NSTextField *incomingArduinoNumInputs;
@property (weak) IBOutlet NSTextField *incomingTestingPath;
@property (weak) IBOutlet NSTextField *incomingRawData;

@property (weak) IBOutlet NSTextField *outgoingPredictedString;
@property (weak) IBOutlet NSTextField *outgoingDimension1;
@property (weak) IBOutlet NSTextField *outgoingDimension2;
@property (weak) IBOutlet NSTextField *outgoingDimension3;
@property (weak) IBOutlet NSTextField *outgoingDimension4;
@property (weak) IBOutlet NSTextField *outgoingDimension5;
@property (weak) IBOutlet NSTextField *outgoingDimension6;
@property (weak) IBOutlet NSTextField *outgoingDimension7;
@property (weak) IBOutlet NSTextField *outgoingDimension8;
@property (weak) IBOutlet NSTextField *outgoingDimension9;
@property (weak) IBOutlet NSTextField *outgoingDimension10;
@property (weak) IBOutlet NSTextField *outgoingAccuracy;



@property (nonatomic) AFSerialCommunicator *mainSerialCommunicator;
@property (nonatomic) AFActionDefinitionStack *mainActionDefinitionStack;
@property (nonatomic) AFSupervisedLearner *mainLearner;

- (IBAction)saveAction:(id)sender;

- (IBAction)submitButtonPressed:(NSButton *)sender;
- (IBAction)loadButtonPressed:(id)sender;
- (IBAction)exportButtonPressed:(id)sender;
- (IBAction)startRecognitionPressed:(id)sender;
- (IBAction)recognizeFromBelowPressed:(id)sender;


- (IBAction)trainButtonPushed:(id)sender;
- (IBAction)predictFromArduinoButtonPushed:(id)sender;
- (IBAction)predictFromFileButtonPushed:(id)sender;
- (IBAction)predictFromRawDataButtonPushed:(id)sender;

@end
