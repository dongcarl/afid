//
// Created by Carl Dong on 7/4/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface AFHashRecognizer : NSMutableDictionary

//initializers
- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
			 keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
			   keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
		  objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex;

- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
				  keyElementsRange:(NSRange)incomingKeyRange
			   objectElementsRange:(NSRange)incomingObjectRange;

- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
			 keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
			   keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
		  objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex
					  outputToFile:(NSString *)incomingOutputFilePath;

- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
				  keyElementsRange:(NSRange)incomingKeyRange
			   objectElementsRange:(NSRange)incomingObjectRange
					  outputToFile:(NSString *)incomingOutputFilePath;


//setters
- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
				keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
				  keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
			 objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			   objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex;

- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
					 keyElementsRange:(NSRange)incomingKeyRange
				  objectElementsRange:(NSRange)incomingObjectRange;

- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
				keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
				  keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
			 objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			   objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex
						 outputToFile:(NSString *)incomingOutputFilePath;

- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
					 keyElementsRange:(NSRange)incomingKeyRange
				  objectElementsRange:(NSRange)incomingObjectRange
						 outputToFile:(NSString *)incomingOutputFilePath;

@end