//
//  AFRecognizer.h
//  afid-gui
//
//  Created by Carl Dong on 7/19/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFRecognizer <NSObject>

- (void)trainWithArff:(NSString *)incomingFilePath;
- (void)trainWithTxt:(NSString *)incomingFilePath;
- (void)trainWithArrayOfActionDefinitions:(NSArray *)incomingArray;

- (NSString *)predictionWithGestureVector:(NSArray *)incomingGestureVector;
- (NSString)


@end