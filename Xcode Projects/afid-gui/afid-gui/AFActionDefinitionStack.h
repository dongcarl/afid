//
// Created by Carl Dong on 7/5/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFActionDefinition.h"
#import <Foundation/Foundation.h>


@interface AFActionDefinitionStack : NSObject

//properties

@property (nonatomic) NSMutableArray *stack;

//initializers
- (AFActionDefinitionStack *)initWithStandardConfigurationForFile:(NSString *)incomingFilePath;

//adding ActionDefinitions
//using ActionDefinitions and GestureVectors
- (void)trainWithActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ...;

- (void)trainWithActionDefinition:(AFActionDefinition *)incomingActionDefinition;

- (void)trainWithGestureVector:(NSArray *)incomingGestureVector
                    bufferSize:(NSUInteger)incomingBufferSize
		   correspondingString:(NSString *)incomingCorrespondingString;

//using files
- (void)trainWithStandardConfigurationsForFile:(NSString *)incomingFilePath;

- (void)trainWithFile:(NSString *)incomingFilePath
        lineSeperator:(NSString *)incomingLineSeperator
	    elementSeperator:(NSString *)incomingElementSeperator
correspondingStringRange:(NSRange)incomingCorrespondingStringRange
	  gestureVectorRange:(NSRange)incomingGestureVectorRange
			  bufferSize:(NSUInteger)incomingBufferSize;

//Recognition
- (NSString *)recognizeWithBoundingboxMethod:(NSArray *)incomingGestureVector;

//exporting
- (NSError *)exportCurrentActionDefinitionStackWithStandardConfigurationTo:(NSString *)exportFilePath;

- (NSError *)exportCurrentActionDefinitionStackTo:(NSString *)exportFilePath
                                    lineSeperator:(NSString *)incomingLineSeperator
			                     elementSeperator:(NSString *)incomingElementSeperator;

@end