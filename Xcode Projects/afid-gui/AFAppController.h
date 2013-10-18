//
//  AFAppController.h
//  afid-gui
//
//  Created by Carl Dong on 7/25/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFSerialCommunicator.h"
#import "AFSupervisedLearner.h"
#import "AFDataset.h"
#import "AFHUDViewController.h"
#import <Foundation/Foundation.h>

@interface AFAppController : NSObject

//Training Inputs
@property (weak) IBOutlet NSTextField *incomingTrainingPath;
@property (weak) IBOutlet NSTextField *incomingFeaturesRangeLocation;
@property (weak) IBOutlet NSTextField *incomingFeaturesRangeLength;
@property (weak) IBOutlet NSTextField *incomingLabelsRangeLocation;
@property (weak) IBOutlet NSTextField *incomingLabelsRangeLength;

//Training Actions
- (IBAction)trainPushed:(id)sender;
- (IBAction)collectPushed:(id)sender;

//Prediction Inputs
@property (weak) IBOutlet NSTextField *incomingNumInputsFromArduino;
@property (weak) IBOutlet NSTextField *incomingTestingPath;
@property (weak) IBOutlet NSTextField *incomingRawData;

//Prediction Actions
- (IBAction)arduinoPredictPushed:(id)sender;
- (IBAction)filePredictPushed:(id)sender;
- (IBAction)rawPredictPushed:(id)sender;

//hudViewController
@property (unsafe_unretained) IBOutlet AFHUDViewController *hudViewController;

@property (weak) IBOutlet NSTextField *incomingExpectedString;
//Models
@property (strong) IBOutlet AFSerialCommunicator *mainSerialCommunicator;
//@property (nonatomic, strong) AFSerialCommunicator *mainSerialCommunicator;
@property (nonatomic, strong) AFSupervisedLearner *mainLearner;
//@property (nonatomic, strong) AFSupervisedLearner *mainLearner;
@property (nonatomic) AFDataset *currentDataset;

//Querying
- (AFDataset *)trainingDataset;
- (AFDataset *)testingDataset;

@end
