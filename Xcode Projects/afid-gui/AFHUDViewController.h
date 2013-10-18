//
//  AFHUDViewController.h
//  afid-gui
//
//  Created by Carl Dong on 7/24/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AFHUDViewController : NSViewController

@property NSUInteger numCorrect;
@property NSUInteger numProcessed;
@property (unsafe_unretained) IBOutlet NSPanel *hudPanel;

@property (weak) IBOutlet NSTextField *outgoingPredictedString;
@property (weak) IBOutlet NSTextField *incomingExpectedString;


@property (weak) IBOutlet NSTextField *incomingInputDimension1;
@property (weak) IBOutlet NSTextField *incomingInputDimension2;
@property (weak) IBOutlet NSTextField *incomingInputDimension3;
@property (weak) IBOutlet NSTextField *incomingInputDimension4;
@property (weak) IBOutlet NSTextField *incomingInputDimension5;
@property (weak) IBOutlet NSTextField *incomingInputDimension6;
@property (weak) IBOutlet NSTextField *incomingInputDimension7;
@property (weak) IBOutlet NSTextField *incomingInputDimension8;
@property (weak) IBOutlet NSTextField *incomingInputDimension9;
@property (weak) IBOutlet NSTextField *incomingInputDimension10;

@property (weak) IBOutlet NSTextField *outgoingAccuracy;

@property (nonatomic) NSArray *inputDimensions;


@property NSUInteger numExpectedDimensions;


- (void)updateFieldsWithArray:(NSArray *)incomingArray
                 expectString:(NSString *)incomingExpectedString;
- (void)resetAll;

@end