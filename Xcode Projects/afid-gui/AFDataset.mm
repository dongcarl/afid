//
//  AFDataset.mm
//  afid-gui
//
//  Created by Carl Dong on 7/19/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFDataset.h"

using namespace GClasses;


@implementation AFDataset

- (GMatrix *)featuresMatrix
{
    if (!_featuresMatrix)
    {
        _featuresMatrix = self.fullMatrix->cloneSub(0, self.featuresRange.location, self.fullMatrix->rows(), self.featuresRange.length);
    }
    return _featuresMatrix;
}

- (GMatrix *)labelsMatrix
{
    if (!_labelsMatrix)
    {
        _labelsMatrix = self.fullMatrix->cloneSub(0, self.labelsRange.location, self.fullMatrix->rows(), self.labelsRange.length);
    }
    return _labelsMatrix;
}

- (std::vector<double*>)fullVector
{
    return [self GMatrixToDoubleStarVector:self.fullMatrix];
}

- (std::vector<double*>)featuresVector
{
    return [self GMatrixToDoubleStarVector:self.featuresMatrix];
}

- (std::vector<double*>)labelsVector
{
    return [self GMatrixToDoubleStarVector:self.labelsMatrix];
}

- (NSArray *)NSFeatures
{
    if (!_NSFeatures)
    {
        _NSFeatures = [self GMatrixToNSAray:self.featuresMatrix];
    }
    return _NSFeatures;
}

- (NSArray *)NSLabels
{
    if (!_NSLabels)
    {
        _NSLabels = [self GMatrixToNSAray:self.labelsMatrix];
    }
    return _NSLabels;
}

- (std::vector<double*>)GMatrixToDoubleStarVector:(GMatrix *)incomingGMatrix
{
    std::vector<double*> result;
    incomingGMatrix->toVector(result[0]);
    return result;
}

- (NSArray *)GMatrixToNSAray:(GMatrix *)incomingGMatrix
{
    NSUInteger rows = incomingGMatrix->rows();
    NSUInteger cols = incomingGMatrix->cols();
    
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:rows];
    
    for (NSUInteger i = 0; i < rows; i++)
    {
        [result addObject:[[NSMutableArray alloc]initWithCapacity:cols]];
        for (NSUInteger v = 0; v < cols; v++)
        {
            [[result objectAtIndex:i] addObject: [[NSNumber alloc]initWithDouble:(incomingGMatrix->row(i))[v]]];
        }
    }
    
    return result;
}

- (GMatrix *)NSArrayToGMatrix:(NSArray *)incomingArray
{
    NSUInteger rows = incomingArray.count;
    NSUInteger cols = [[incomingArray objectAtIndex:0] count];
    
    GMatrix *result = new GMatrix(rows, cols);
    
    for (int i = 0; i < rows; i++)
    {
        for (int v = 0; i < cols; i++)
        {
            *result[i][v] = [[[incomingArray objectAtIndex:i] objectAtIndex:v] doubleValue];
        }
    }
    return result;
}



- (id)initWithGMatrix:(GMatrix *)incomingGMatrix
         featureRange:(NSRange)incomingFeatureRange
           labelRange:(NSRange)incomingLabelRange
{
    if (self = [super init])
    {
        
        self.fullMatrix = new GMatrix(*incomingGMatrix);
//        Holder<GMatrix> hM(self.fullMatrix);
//        NSLog(@"initializing with gmatrix");
//        self.fullMatrix->print(std::cout);
        
        self.featuresRange = incomingFeatureRange;
        self.labelsRange = incomingLabelRange;
        
//        NSLog(@"Dataset initalized with features:");
//        self.featuresMatrix->print(std::cout);
    }
    return self;
}


- (id)initWithARFF:(NSString *)incomingFilePath
      featureRange:(NSRange)incomingFeatureRange
        labelRange:(NSRange)incomingLabelRange;
{
    return [self initWithGMatrix:GMatrix::loadArff([incomingFilePath UTF8String]) featureRange:incomingFeatureRange labelRange:incomingLabelRange];
}

- (id)initWithTxt:(NSString *)incomingFilePath
     featureRange:(NSRange)incomingFeatureRange
       labelRange:(NSRange)incomingLabelRange
{
    return [self initWithGMatrix:GMatrix::loadCsv([incomingFilePath UTF8String], ',', false, false) featureRange:incomingFeatureRange labelRange:incomingLabelRange];
}

- (id)initWithArray:(NSArray *)incomingArray
       featureRange:(NSRange)incomingFeatureRange
         labelRange:(NSRange)incomingLabelRange
{
    return [self initWithGMatrix:[self NSArrayToGMatrix:incomingArray] featureRange:incomingFeatureRange labelRange:incomingLabelRange];
    
}

- (NSString *)labelForPrediction:(double *)incomingPrediction
{
    return [self labelForPrediction:incomingPrediction atColumn:self.labelsRange.location];
}

- (NSString *)labelForPrediction:(double *)incomingPrediction
                        atColumn:(NSUInteger)incomingCol
{
    std::ostringstream stream;
    self.fullMatrix->relation()->printAttrValue(stream, incomingCol, *incomingPrediction);
	return [[NSString alloc]initWithCString:stream.str().c_str() encoding:[NSString defaultCStringEncoding]];
}

- (NSArray *)labelsForPredictions:(double *)incomingPredictions
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSUInteger size = (sizeof(*incomingPredictions)/incomingPredictions[0]);
    
    for (int i = 0; i < size; i++)
    {
        [result addObject:[self labelForPrediction:&(incomingPredictions[i]) atColumn:self.labelsRange.location+i]];
    }
    
    return result;
}

@end
