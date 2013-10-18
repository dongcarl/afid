//
//  AFDataset.h
//  afid-gui
//
//  Created by Carl Dong on 7/19/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
#ifdef __cplusplus
#include <GClasses/GMatrix.h>
#endif

#import <Foundation/Foundation.h>

@interface AFDataset : NSObject

@property (nonatomic, strong) NSArray *NSFeatures;
@property (nonatomic, strong) NSArray *NSLabels;
@property NSRange featuresRange;
@property NSRange labelsRange;

#ifdef __cplusplus
@property (nonatomic) GClasses::GMatrix *fullMatrix;
@property (nonatomic) GClasses::GMatrix *featuresMatrix;
@property (nonatomic) GClasses::GMatrix *labelsMatrix;
@property (nonatomic) std::vector<double*> fullVector;
@property (nonatomic) std::vector<double*> featuresVector;
@property (nonatomic) std::vector<double*> labelsVector;
#endif


//initializers
- (id)initWithARFF:(NSString *)incomingFilePath
      featureRange:(NSRange)incomingFeatureRange
        labelRange:(NSRange)incomingLabelRange;
- (id)initWithTxt:(NSString *)incomingFilePath
     featureRange:(NSRange)incomingFeatureRange
       labelRange:(NSRange)incomingLabelRange;
- (id)initWithArray:(NSArray *)incomingArray
       featureRange:(NSRange)incomingFeatureRange
         labelRange:(NSRange)incomingLabelRange;

//others
- (NSString *)labelForPrediction:(double *)incomingPrediction;
- (NSArray *)labelsForPredictions:(double *)incomingPredictions;


@end
