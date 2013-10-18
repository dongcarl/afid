//
//  AFHUDViewController.m
//  afid-gui
//
//  Created by Carl Dong on 7/24/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFHUDViewController.h"

@implementation AFHUDViewController

-(id)init
{
    if (self = [super init])
    {
        self.numExpectedDimensions = 10;
    }
    return self;
}

-(NSArray *)inputDimensions
{
    return [[NSArray alloc]initWithObjects:self.incomingInputDimension1,
            self.incomingInputDimension2,
            self.incomingInputDimension3,
            self.incomingInputDimension4,
            self.incomingInputDimension5,
            self.incomingInputDimension6,
            self.incomingInputDimension7,
            self.incomingInputDimension8,
            self.incomingInputDimension9,
            self.incomingInputDimension10,nil];
}

- (void)updateFieldsWithArray:(NSArray *)incomingArray
                 expectString:(NSString *)incomingExpectedString
{
    NSLog(@"inside updateFieldsWithArray with %@ and %@", incomingArray, incomingExpectedString);
    if (incomingArray.count == 10)
    {
        //        for (int i = 0; i < 10; i++)
        //        {
        //            switch (i)
        //            {
        //                case 0:
        //                    self.incomingInputDimension1.stringValue = [incomingArray objectAtIndex:i];
        //                    NSLog(@"incomingdimension1 is now %@", self.incomingInputDimension1.stringValue);
        //                    break;
        //
        //                case 1:
        //                    self.incomingInputDimension2.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 2:
        //                    self.incomingInputDimension3.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 3:
        //                    self.incomingInputDimension4.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 4:
        //                    self.incomingInputDimension5.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 5:
        //                    self.incomingInputDimension6.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 6:
        //                    self.incomingInputDimension7.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 7:
        //                    self.incomingInputDimension8.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 8:
        //                    self.incomingInputDimension9.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                case 9:
        //                    self.incomingInputDimension10.stringValue = [incomingArray objectAtIndex:i];
        //                    break;
        //
        //                default:
        //                    break;
        //            }
        //
        //        }
        
        for (int i = 0; i < self.inputDimensions.count; i++)
        {
            NSTextField *currentTextField = [self.inputDimensions objectAtIndex:i];
            currentTextField.integerValue = [[incomingArray objectAtIndex:i] integerValue];
        }
        
        self.outgoingPredictedString.stringValue = incomingExpectedString;
        if ([incomingExpectedString isEqualTo:incomingExpectedString])
        {
            self.numCorrect++;
        }
        self.numProcessed++;
        
        self.outgoingAccuracy.doubleValue = (double)self.numCorrect/self.numProcessed;
        
        NSLog(@"outgoing accuracy: %@", self.outgoingAccuracy.stringValue);
        
        NSLog(@"going to perform selector");
        [self.inputDimensions makeObjectsPerformSelector:@selector(display)];
        [self.outgoingPredictedString display];
//        [self.incomingInputDimension1 display];
//        dispatch_async(dispatch_get_main_queue(), ^{
//           [self.incomingInputDimension1 setNeedsDisplay:YES];
//        });
//        [self.incomingInputDimension1 performSelectorOnMainThread:@selector(setNeedsDisplay:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        //        NSLog(self.incomingInputDimension1.needsDisplay ? @"Yes" : @"No");
    }
    else
    {
        NSLog(@"not the right amount of dimensions... recieved %lu instead of the expected %lu", (unsigned long)incomingArray.count, (unsigned long)self.numExpectedDimensions);
    }
}

- (void)resetAll
{
    self.outgoingPredictedString.stringValue = @"";
    self.incomingExpectedString.stringValue = @"";
    
    self.incomingInputDimension1.stringValue = @"000";
    self.incomingInputDimension2.stringValue = @"000";
    self.incomingInputDimension3.stringValue = @"000";
    self.incomingInputDimension4.stringValue = @"000";
    self.incomingInputDimension5.stringValue = @"000";
    self.incomingInputDimension6.stringValue = @"000";
    self.incomingInputDimension7.stringValue = @"000";
    self.incomingInputDimension8.stringValue = @"000";
    self.incomingInputDimension9.stringValue = @"000";
    self.incomingInputDimension10.stringValue = @"000";
    
    self.outgoingAccuracy.stringValue = @"000.000%";
    
    self.numCorrect = 0;
    self.numProcessed = 0;
    
    [self.view needsDisplay];
    
}

@end
