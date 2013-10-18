//
// Created by Carl Dong on 7/7/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#ifdef __cplusplus
#include <GClasses/GMatrix.h>
#include <GClasses/GKNN.h>
#include <GClasses/GRand.h>
#endif

#import "AFDataset.h"

@interface AFSupervisedLearner : NSObject

@property (nonatomic) AFDataset *currentDataSet;

#ifdef __cplusplus
@property (nonatomic) GClasses::GKNN *cppSelf;
#endif

//initializers
- (id)initWithDataSet:(AFDataset *)incomingDataSet
             autotune:(BOOL)incomingAutoTuneDecision
                train:(BOOL)incomingTrainDecision;

//others
- (void)autoTuneWithCurrentDataSet;
- (void)autoTuneWithDataSet:(AFDataset *)incomingDataSet;
- (void)trainWithCurrentDataSet;
- (void)trainWithDataSet:(AFDataset *)incomingDataSet;
- (NSString *)predictionFromGestureVector:(NSArray *)incomingGestureVector;

@end