//
//  AFAppController.m
//  afid-gui
//
//  Created by Carl Dong on 7/25/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFAppController.h"

@implementation AFAppController

- (IBAction)trainPushed:(id)sender
{
    NSRange featuresRange = NSMakeRange(self.incomingFeaturesRangeLocation.integerValue, self.incomingFeaturesRangeLength.integerValue);
    NSRange labelsRange = NSMakeRange(self.incomingLabelsRangeLocation.integerValue, self.incomingLabelsRangeLength.integerValue);
    
    
    //make tilde path full path
    if (![self.incomingTrainingPath.stringValue isAbsolutePath])
    {
        self.incomingTrainingPath.stringValue = [self.incomingTrainingPath.stringValue stringByExpandingTildeInPath];
    }
    [self.hudViewController.view needsDisplay];
    
    //load data into dataset
    if ([self.incomingTrainingPath.stringValue hasSuffix:@".arff"])
    {
        NSLog(@"initializing dataset as arff file");
        self.currentDataset = [[AFDataset alloc]initWithARFF:self.incomingTrainingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    else
    {
        NSLog(@"initializing dataset as plain text file");
        self.currentDataset = [[AFDataset alloc]initWithTxt:self.incomingTrainingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    
    //train and autotune model with dataset
    NSLog(@"first line of dataset: %@", [self.currentDataset.NSFeatures objectAtIndex:0]);
    self.mainLearner = [[AFSupervisedLearner alloc]initWithDataSet:self.currentDataset autotune:YES train:YES];
    NSLog(@"learned");
    
    NSLog(@"training finished with %@", self.currentDataset.NSFeatures);
    
}

- (IBAction)collectPushed:(id)sender
{
    NSError *error;
    
    NSMutableString *stringToBeWritten;
    for (NSUInteger i = 0; i < self.incomingNumInputsFromArduino.integerValue; i++)
    {
        NSArray *incomingLineArrayFromArduino = self.mainSerialCommunicator.nextGestureVector;
        for (id v in incomingLineArrayFromArduino)
        {
            [stringToBeWritten appendFormat:@"%@,",[v stringValue]];
            
            if (v == incomingLineArrayFromArduino.lastObject)
            {
                [stringToBeWritten appendFormat:@"%@%c", self.incomingExpectedString.stringValue, '\n'];
            }
        }
    }
    [stringToBeWritten writeToFile:self.incomingTrainingPath.stringValue atomically:NO encoding:NSUTF8StringEncoding error:&error];
}

- (IBAction)arduinoPredictPushed:(id)sender
{
    [self.hudViewController resetAll];
    
    for (NSUInteger i = 0; i < self.incomingNumInputsFromArduino.integerValue; i++)
    {
        NSArray *incomingArray = [self.mainSerialCommunicator nextGestureVector];
        [self.hudViewController updateFieldsWithArray:incomingArray expectString:[self.mainLearner predictionFromGestureVector:incomingArray]];
    }
}

- (IBAction)filePredictPushed:(id)sender
{
    [self.hudViewController resetAll];
    
    NSRange featuresRange = NSMakeRange(self.incomingFeaturesRangeLocation.integerValue, self.incomingFeaturesRangeLength.integerValue);
    NSRange labelsRange = NSMakeRange(self.incomingLabelsRangeLocation.integerValue, self.incomingLabelsRangeLength.integerValue);
        
    AFDataset *testingData;
    
    if ([self.incomingTestingPath.stringValue hasSuffix:@".arff"])
    {
        NSLog(@"initializing testing data as arff");
        testingData = [[AFDataset alloc]initWithARFF:self.incomingTestingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    else
    {
        NSLog(@"initializing testing data as plain text");
        testingData = [[AFDataset alloc]initWithTxt:self.incomingTestingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    
    for (NSUInteger i = 0; i < testingData.NSFeatures.count;i++)
    {     
        double incomingStringValue = [[[testingData.NSLabels objectAtIndex:i] objectAtIndex:0]doubleValue];
//        double *pDouble = &incomingStringValue;
        
        [self.hudViewController
         updateFieldsWithArray:[testingData.NSFeatures objectAtIndex:i]
         expectString:[testingData labelForPrediction:&incomingStringValue]];
    }
}

- (IBAction)rawPredictPushed:(id)sender
{
    NSArray *incomingArray = [self.incomingRawData.stringValue componentsSeparatedByString:@","];
    [self.hudViewController updateFieldsWithArray:incomingArray expectString:@""];
}

- (AFDataset *)trainingDataset
{
    NSRange featuresRange = NSMakeRange(self.incomingFeaturesRangeLocation.integerValue, self.incomingFeaturesRangeLength.integerValue);
    NSRange labelsRange = NSMakeRange(self.incomingLabelsRangeLocation.integerValue, self.incomingLabelsRangeLength.integerValue);
    
    if ([self.incomingTrainingPath.stringValue hasSuffix:@".arff"])
    {
        NSLog(@"initializing dataset as arff file");
        self.currentDataset = [[AFDataset alloc]initWithARFF:self.incomingTrainingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    else
    {
        NSLog(@"initializing dataset as plain text file");
        self.currentDataset = [[AFDataset alloc]initWithTxt:self.incomingTrainingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    
    return self.currentDataset;
}

- (AFDataset *)testingDataset
{
    NSRange featuresRange = NSMakeRange(self.incomingFeaturesRangeLocation.integerValue, self.incomingFeaturesRangeLength.integerValue);
    NSRange labelsRange = NSMakeRange(self.incomingLabelsRangeLocation.integerValue, self.incomingLabelsRangeLength.integerValue);
    
    if ([self.incomingTestingPath.stringValue hasSuffix:@".arff"])
    {
        NSLog(@"initializing testing data as arff");
        self.currentDataset = [[AFDataset alloc]initWithARFF:self.incomingTestingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    else
    {
        NSLog(@"initializing testing data as plain text");
        self.currentDataset = [[AFDataset alloc]initWithTxt:self.incomingTestingPath.stringValue featureRange:featuresRange labelRange:labelsRange];
    }
    
    return self.currentDataset;
}


@end
