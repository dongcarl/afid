//
// Created by Carl Dong on 7/7/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface AFSupervisedLearner : NSObject

- (id)initWithTrainingFile:(NSString *)incomingARFFTrainingFilePath
               testingFile:(NSString *)incomingARFFTestingFilePath
        featureColumnRange:(NSRange)incomingFeatureColumnRange
          labelColumnRange:(NSRange)incomingLabelColumnRange;

@property (nonatomic) NSString *ARFFTrainingFilePath;
@property (nonatomic) NSString *ARFFTestingFilePath;
@property (nonatomic) NSDictionary *predictionDefinition;


//initializers


- (void)autoTune;
- (void)train;
- (NSString *)predictionFromGestureVector:(NSArray *)incomingGestureVector;

//helpers

@end