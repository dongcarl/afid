//
// Created by Carl Dong on 7/15/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol AFSupervisedLearnerWrapper <NSObject>

@required
- (void)train;
- (NSString *)predictionFromGestureVector:(NSArray *)incomingGestureVector;

@optional
- (void)autoTune;

@end