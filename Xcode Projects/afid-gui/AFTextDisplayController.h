//
//  AFTextDisplayController.h
//  afid-gui
//
//  Created by Carl Dong on 7/30/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFDataset.h"
#import "AFAppController.h"
#import "AFSupervisedLearner.h"
#import "AFSerialCommunicator.h"
#import <Cocoa/Cocoa.h>

@interface AFTextDisplayController : NSViewController

@property (weak) IBOutlet AFAppController *mainAppController;
@property (unsafe_unretained) IBOutlet NSTextView *mainTextView;
@property (weak) IBOutlet AFSerialCommunicator *mainSerialCommunicator;
- (IBAction)startTypingPushed:(id)sender;

@end