//
//  AFTextDisplayController.m
//  afid-gui
//
//  Created by Carl Dong on 7/30/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFTextDisplayController.h"

@implementation AFTextDisplayController

- (IBAction)startTypingPushed:(id)sender
{
    NSString *thisPrediction;
    NSString *lastPrediction = [[NSString alloc]init];

    if (self.mainTextView) NSLog(@"textView is not nil");
    NSLog(@"going to init the dataset");
    NSArray *inputs = [[self.mainAppController testingDataset] NSFeatures];
    
    
    NSLog(@"inputs: %@",inputs);
    
    for (int i = 0; YES; i++)
    {
        NSLog(@"infor loop");
        thisPrediction = [self.mainAppController.mainLearner predictionFromGestureVector:[inputs objectAtIndex:i]];
        NSLog(@"this prediction: %@", thisPrediction);
        if ([thisPrediction isNotEqualTo:lastPrediction])
        {
            self.mainTextView.string = [self.mainTextView.string stringByAppendingString:thisPrediction];
            [self.mainTextView display];
            lastPrediction = thisPrediction;
        }
    }
}
@end
