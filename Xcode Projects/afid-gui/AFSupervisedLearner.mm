//
// Created by Carl Dong on 7/7/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//
#import <Foundation/Foundation.h>
#import "AFSupervisedLearner.h"
#include <mach/mach_time.h>


using namespace GClasses;

@interface AFSupervisedLearner ()
{

}

@end

@implementation AFSupervisedLearner

- (GClasses::GKNN *)cppSelf
{
    if (!_cppSelf)
    {
        uint64_t seed = mach_absolute_time();
        _cppSelf = new GKNN(*(new GRand(seed)));
    }
    return _cppSelf;
}

- (id)initWithDataSet:(AFDataset *)incomingDataSet
             autotune:(BOOL)incomingAutoTuneDecision
                train:(BOOL)incomingTrainDecision
{
    NSLog(@"going to init");
    if (self = [super init])
    {
        NSLog(@"super initted, going to set dataset");
        self.currentDataSet = incomingDataSet;
        
        if(self.cppSelf == nil)
        {
            NSLog(@"it is nil!");
        }
        
        NSLog(@"dataset is set, going to autotune");
        if (incomingAutoTuneDecision)
        {[self autoTuneWithCurrentDataSet];}
        NSLog(@"autotuned, going to train");
        if (incomingTrainDecision)
        {[self trainWithCurrentDataSet];}
        NSLog(@"trained, init finished");
    }
    return self;
}

- (void)trainWithCurrentDataSet
{
	[self trainWithDataSet:self.currentDataSet];
}

- (void)autoTuneWithCurrentDataSet
{
    [self autoTuneWithDataSet:self.currentDataSet];
}

- (void)autoTuneWithDataSet:(AFDataset *)incomingDataSet
{
    self.cppSelf->autoTune(*incomingDataSet.featuresMatrix, *incomingDataSet.labelsMatrix);
}

- (void)trainWithDataSet:(AFDataset *)incomingDataSet
{
    NSLog(@"going to train... and I am  %p", self);
    self.cppSelf->train(*[incomingDataSet featuresMatrix], *[incomingDataSet labelsMatrix]);
}

- (NSString *)predictionFromGestureVector:(NSArray *)incomingGestureVector
{
    NSLog(@"in method of interest");
    NSLog(@"in prediction from... with... %@",incomingGestureVector);
    NSUInteger numberOfDimensions = incomingGestureVector.count;
    double c_incomingGestureVector[numberOfDimensions];
    NSLog(@"declared c_incomingGestureVector, going to populate");
    for (int i = 0; i < numberOfDimensions; i++)
    {
        c_incomingGestureVector[i] = [[incomingGestureVector objectAtIndex:i]doubleValue];
    }
    NSLog(@"set up the c_incomingGestureVector");
    NSLog(@"going to print c_incomingGestureVector");
    
    for (int i = 0 ; i < numberOfDimensions; i++)
    {
        NSLog(@"the %dth element in the array is %f", i, c_incomingGestureVector[i]);
    }
    
    double pOut[1];
    NSLog(@"declared pOut, going to predict");
    NSLog(@"going to predict, and i am %p", self);
    self.cppSelf->predict(c_incomingGestureVector, pOut);
    NSLog(@"prediction completed");
    NSLog(@"pOut: %f", pOut[0]);
    return [self.currentDataSet labelForPrediction:pOut];
}

@end
