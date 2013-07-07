//
// Created by Carl Dong on 7/4/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFHashRecognizer.h"


@implementation AFHashRecognizer

//initializers
- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
			 keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
			   keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
		  objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex
{
	return [self initWithFile:incomingFilePath
	            lineSeperator:incomingLineSeperator
	         elementSeperator:incomingElementSeperator
		keyElementsStartIndex:incomingKeyStartIndex
		  keyElementsEndIndex:incomingKeyEndIndex
	 objectElementsStartIndex:incomingObjectStartIndex
	   objectElementsEndIndex:incomingObjectEndIndex
				 outputToFile:NULL];

}

- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
				  keyElementsRange:(NSRange)incomingKeyRange
			   objectElementsRange:(NSRange)incomingObjectRange
{
	return [self initWithFile:incomingFilePath lineSeperator:incomingLineSeperator
	         elementSeperator:incomingElementSeperator keyElementsRange:incomingKeyRange
		  objectElementsRange:incomingObjectRange outputToFile:NULL];
}

- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
			 keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
			   keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
		  objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex
					  outputToFile:(NSString *)incomingOutputFilePath
{
	NSRange incomingKeyRange =      {.location = incomingKeyStartIndex,     .length = incomingKeyEndIndex - incomingKeyStartIndex       };
	NSRange incomingObjectRange =   {.location = incomingObjectStartIndex,  .length = incomingObjectEndIndex - incomingObjectStartIndex };

	return [self initWithFile:incomingFilePath lineSeperator:incomingLineSeperator
	         elementSeperator:incomingElementSeperator keyElementsRange:incomingKeyRange
		  objectElementsRange:incomingObjectRange outputToFile:incomingOutputFilePath];
}

- (AFHashRecognizer *)initWithFile:(NSString *)incomingFilePath
                     lineSeperator:(NSString *)incomingLineSeperator
			      elementSeperator:(NSString *)incomingElementSeperator
				  keyElementsRange:(NSRange)incomingKeyRange
			   objectElementsRange:(NSRange)incomingObjectRange
					  outputToFile:(NSString *)incomingOutputFilePath
{
	if (self = [super init])
	{
		[self setKeysAndDefinitionsFromFile:incomingFilePath
		                      lineSeperator:incomingLineSeperator
					       elementSeperator:incomingElementSeperator
						   keyElementsRange:incomingKeyRange
						objectElementsRange:incomingObjectRange
							   outputToFile:incomingOutputFilePath];
	}
	return self;
}

//setters...
- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
				keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
				  keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
			 objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			   objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex
{
	[self setKeysAndDefinitionsFromFile:incomingFilePath
	                      lineSeperator:incomingLineSeperator
				       elementSeperator:incomingElementSeperator
				  keyElementsStartIndex:incomingKeyStartIndex
					keyElementsEndIndex:incomingKeyEndIndex
			   objectElementsStartIndex:incomingObjectStartIndex
				 objectElementsEndIndex:incomingObjectEndIndex
						   outputToFile:NULL];
}

- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
					 keyElementsRange:(NSRange)incomingKeyRange
				  objectElementsRange:(NSRange)incomingObjectRange
{
	[self setKeysAndDefinitionsFromFile:incomingFilePath
	                      lineSeperator:incomingLineSeperator
				       elementSeperator:incomingElementSeperator
					   keyElementsRange:incomingKeyRange
					objectElementsRange:incomingObjectRange
						   outputToFile:NULL];
}

- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
				keyElementsStartIndex:(NSUInteger)incomingKeyStartIndex
				  keyElementsEndIndex:(NSUInteger)incomingKeyEndIndex
			 objectElementsStartIndex:(NSUInteger)incomingObjectStartIndex
			   objectElementsEndIndex:(NSUInteger)incomingObjectEndIndex
						 outputToFile:(NSString *)incomingOutputFilePath
{
	NSRange incomingKeyRange =      {.location = incomingKeyStartIndex,     .length = incomingKeyEndIndex - incomingKeyStartIndex       };
	NSRange incomingObjectRange =   {.location = incomingObjectStartIndex,  .length = incomingObjectEndIndex - incomingObjectStartIndex };

	[self setKeysAndDefinitionsFromFile:incomingFilePath lineSeperator:incomingLineSeperator
	                   elementSeperator:incomingElementSeperator keyElementsRange:incomingKeyRange
					objectElementsRange:incomingObjectRange outputToFile:incomingOutputFilePath];
}

- (void)setKeysAndDefinitionsFromFile:(NSString *)incomingFilePath
                        lineSeperator:(NSString *)incomingLineSeperator
			         elementSeperator:(NSString *)incomingElementSeperator
					 keyElementsRange:(NSRange)incomingKeyRange
				  objectElementsRange:(NSRange)incomingObjectRange
						 outputToFile:(NSString *)incomingOutputFilePath
{
	NSError *errorReadingFromFile;
	NSStringEncoding encodingOfFile;
	NSString *incomingFile = [[NSString alloc] initWithContentsOfFile:incomingFilePath
	                                                     usedEncoding:&encodingOfFile
				                                                error:&errorReadingFromFile];
	NSArray *linesOfIncomingFile = [[NSArray alloc] initWithArray:[incomingFile componentsSeparatedByString:incomingLineSeperator]];

	for (NSString *currentLine in linesOfIncomingFile)
	{
		NSArray *seperatedElementsOfCurrentLine = [currentLine componentsSeparatedByString:incomingElementSeperator];

		if (incomingKeyRange.length == 1)
		{
			if (incomingObjectRange.length == 1)
			{
				[self setObject:[seperatedElementsOfCurrentLine objectAtIndex:incomingObjectRange.location]
				         forKey:[seperatedElementsOfCurrentLine objectAtIndex:incomingKeyRange.location]];
			}
			else
			{
				NSArray *incomingObjectArray = [seperatedElementsOfCurrentLine subarrayWithRange:incomingObjectRange];
				[self setObject:incomingObjectArray
				         forKey:[seperatedElementsOfCurrentLine objectAtIndex:incomingKeyRange.location]];
			}
		}
		else
		{
			if (incomingObjectRange.length == 1)
			{
				NSArray *incomingKeyArray = [seperatedElementsOfCurrentLine subarrayWithRange:incomingKeyRange];
				[self setObject:[seperatedElementsOfCurrentLine objectAtIndex:incomingObjectRange.location]
				         forKey:incomingKeyArray];
			}
			else
			{
				NSArray *incomingObjectArray = [seperatedElementsOfCurrentLine subarrayWithRange:incomingObjectRange];
				NSArray *incomingKeyArray = [seperatedElementsOfCurrentLine subarrayWithRange:incomingKeyRange];
				[self setObject:incomingObjectArray
				         forKey:incomingKeyArray];
			}
		}
	}

	if (incomingOutputFilePath)
	{
		[self writeToFile:incomingOutputFilePath atomically:YES];
	}

}

//things you can do...


@end