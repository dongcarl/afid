//
// Created by Carl Dong on 7/7/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//
#import <Foundation/Foundation.h>
#import "AFSupervisedLearner.h"

#include <GClasses/GMatrix.h>
#include <GClasses/GHolders.h>
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
    GClasses::GMatrix *testingData; 
    GClasses::GDecisionTree *cppSelf;
}

//@property (nonatomic) GClasses::GMatrix *features;
//@property (nonatomic) GClasses::GMatrix *labels;
//@property (nonatomic) GClasses::GMatrix *testingData;
//
//@property (nonatomic, readwrite, assign) GClasses::GSupervisedLearner *cppSelf;

@end

@implementation AFSupervisedLearner

@synthesize ARFFTrainingFilePath = _ARFFTrainingFilePath;
@synthesize ARFFTestingFilePath = _ARFFTestingFilePath;


using namespace GClasses;

- (id)initWithTrainingFile:(NSString *)incomingARFFTrainingFilePath
               testingFile:(NSString *)incomingARFFTestingFilePath
        featureColumnRange:(NSRange)incomingFeatureColumnRange
          labelColumnRange:(NSRange)incomingLabelColumnRange;
{
	if (self = [super init])
	{
        self.ARFFTrainingFilePath = incomingARFFTrainingFilePath;
        GMatrix* pTrainingData = GMatrix::loadArff([incomingARFFTrainingFilePath UTF8String]);
        
        self.ARFFTestingFilePath = incomingARFFTestingFilePath;
        GMatrix* pTestingData = GMatrix::loadArff([incomingARFFTestingFilePath UTF8String]);
        
        features = pTrainingData->cloneSub(0, incomingFeatureColumnRange.location, pTrainingData->rows(), incomingFeatureColumnRange.length);
        labels = pTrainingData->cloneSub(0, incomingLabelColumnRange.location, pTrainingData->rows(), incomingLabelColumnRange.length);
        testingData = pTestingData;
        GClasses::GRand *rand = new GClasses::GRand(0);
        cppSelf = new GDecisionTree(*rand);
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
	GClasses::GMatrix *incomingGestureVectorMatrix = new GClasses::GMatrix(1, incomingGestureVector.count);
    GMatrix &M = *incomingGestureVectorMatrix;
	for (int i = 0; i < incomingGestureVector.count; i++)
	{
		M[0][i] = [[incomingGestureVector objectAtIndex:i] integerValue];
	}
    
    double pOut[1];
    
    incomingGestureVectorMatrix->print(std::cout);
    
    cppSelf->predict(incomingGestureVectorMatrix->row(0), pOut);
    
    std::ostringstream stream;
    labels->relation()->printAttrValue(stream, 0, pOut[0]);
    
    std::cout << pOut[0];
    
    NSString *result = [[NSString alloc]initWithCString:stream.str().c_str() encoding:[NSString defaultCStringEncoding]];
    
//    for (long i = 0; i < features->rows(); i++)
//    {
//        double pred[1];
//        cppSelf->predict(features->row(i), pred);
////        NSLog(@"gestureVector: %f", *incomingGestureVectorMatrix->row(i));
//        
//        std::ostringstream stream3;
//        labels->relation()->printAttrValue(stream3, 0, pred[0]);
//        NSLog(@"predicted as: %s", stream3.str().c_str());
//    }
    
	return result;
}

@end
