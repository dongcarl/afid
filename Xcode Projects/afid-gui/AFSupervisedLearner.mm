//
// Created by Carl Dong on 7/7/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//
#import <Foundation/Foundation.h>
#import "AFSupervisedLearner.h"

#include <GClasses/GMatrix.h>
#include <GClasses/GLearner.h>
#include <GClasses/GDecisionTree.h>
#include <GClasses/GNeuralNet.h>
#include <GClasses/GEnsemble.h>
#include <GClasses/GPolynomial.h>
#include <GClasses/GRand.h>
#include <GClasses/GGaussianProcess.h>
#include <GClasses/GLinear.h>
#include <GClasses/GNaiveBayes.h>
#include <GClasses/GKNN.h>
#include <GClasses/GNaiveInstance.h>

@interface AFSupervisedLearner ()
{
    GClasses::GMatrix *features;
    GClasses::GMatrix *labels;
    GClasses::GKNN *cppSelf;
}

@end

@implementation AFSupervisedLearner

@synthesize ARFFTrainingFilePath = _ARFFTrainingFilePath;


using namespace GClasses;

- (id)initWithTrainingFile:(NSString *)incomingARFFTrainingFilePath
        featureColumnRange:(NSRange)incomingFeatureColumnRange
          labelColumnRange:(NSRange)incomingLabelColumnRange;
{
	if (self = [super init])
	{
        self.ARFFTrainingFilePath = incomingARFFTrainingFilePath;
        GClasses::GMatrix* pTrainingData = GClasses::GMatrix::loadArff([incomingARFFTrainingFilePath UTF8String]);
                
        features = pTrainingData->cloneSub(0, incomingFeatureColumnRange.location, pTrainingData->rows(), incomingFeatureColumnRange.length);
        labels = pTrainingData->cloneSub(0, incomingLabelColumnRange.location, pTrainingData->rows(), incomingLabelColumnRange.length);
        GClasses::GRand *rand = new GClasses::GRand(0);
        cppSelf = new GClasses::GKNN(*rand);
	}
    return self;
}

- (void)train
{
	cppSelf->train(*features, *labels);
}

- (void)autoTune
{
    cppSelf->autoTune(*features, *labels);
}

- (NSString *)predictionFromGestureVector:(NSArray *)incomingGestureVector
{    
    NSUInteger numberOfDimensions = incomingGestureVector.count;
    double c_incomingGestureVector[numberOfDimensions];
    for (int i = 0; i < numberOfDimensions; i++)
    {
        c_incomingGestureVector[i] = [[incomingGestureVector objectAtIndex:i]doubleValue];
    }
    
    double pOut[1];
    cppSelf->predict(c_incomingGestureVector, pOut);
    
    std::ostringstream stream;
    labels->relation()->printAttrValue(stream, 0, pOut[0]);
    
    
    NSString *result = [[NSString alloc]initWithCString:stream.str().c_str() encoding:[NSString defaultCStringEncoding]];
    
	return result;
}

- (NSNumber *)accuracyWithARFFFile:(NSString *)incomingTestingARFFFilePath;
{
    NSNumber *resultingAccuracy;
    
    GClasses::GMatrix* incomingTestingDataWithLabel = GClasses::GMatrix::loadArff([incomingTestingARFFFilePath UTF8String]);
    GClasses::GMatrix *incomingTestingDataWithoutLabel = incomingTestingDataWithLabel->cloneSub(0, 0, incomingTestingDataWithLabel->rows(), 10);
    NSUInteger numberOfSuccessfulMatches = 0;
    
    for (int i = 0; i < incomingTestingDataWithoutLabel->rows(); i++)
    {
        double pOut[1];
        self->cppSelf->predict(incomingTestingDataWithoutLabel->row(i), pOut);
        if (pOut[0] == (*incomingTestingDataWithLabel)[i][10])
        {
            numberOfSuccessfulMatches++;
        }
    }
    
    resultingAccuracy = [[NSNumber alloc]initWithDouble:(((double)numberOfSuccessfulMatches) / incomingTestingDataWithLabel->rows())];
    return resultingAccuracy;
}

@end
