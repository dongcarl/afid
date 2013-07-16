//
// Created by Carl Dong on 7/5/13.
// Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFActionDefinitionStack.h"


@implementation AFActionDefinitionStack

@synthesize stack = _stack;

- (NSMutableArray *)stack
{
	if (!_stack)
	{
		_stack = [[NSMutableArray alloc]init];
	}
	return _stack;
}

- (AFActionDefinitionStack *)initWithStandardConfigurationForFile:(NSString *)incomingFilePath
{
	if (self = [super init])
	{
		[self trainWithStandardConfigurationsForFile:incomingFilePath];
	}
	return self;
}

- (void)trainWithActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ...
{
	va_list args;
	va_start(args, incomingActionDefinition1);
	for (AFActionDefinition *arg = incomingActionDefinition1; arg != nil; arg = va_arg(args, AFActionDefinition*))
	{
		[self trainWithActionDefinition:arg];
	}
	va_end(args);
}

- (void)trainWithActionDefinition:(AFActionDefinition *)incomingActionDefinition
{
	if (self.stack.count == 0)
	{
		[self.stack addObject:incomingActionDefinition];
	}
	else
	{
		for (AFActionDefinition *currentActionDefinition in self.stack)
		{
			if ([currentActionDefinition.correspondingString isEqualTo:incomingActionDefinition.correspondingString])
			{
				[currentActionDefinition modifyBoundsWithActionDefinition:incomingActionDefinition];
				break;
			}
			else if (currentActionDefinition == self.stack.lastObject)
			{
				[self.stack addObject:incomingActionDefinition];
			}
		}
	}
}

- (void)trainWithGestureVector:(NSArray *)incomingGestureVector
                    bufferSize:(NSUInteger)incomingBufferSize
		   correspondingString:(NSString *)incomingCorrespondingString
{
	AFActionDefinition *incomingActionDefinition = [[AFActionDefinition alloc] initWithGestureVector:incomingGestureVector
	                                                                                       andBuffer:incomingBufferSize
			                                                                               forString:incomingCorrespondingString];
	[self trainWithActionDefinition:incomingActionDefinition];
}

- (void)trainWithStandardConfigurationsForFile:(NSString *)incomingFilePath
{
	NSRange defaultCorrespondingStringRange = {.location = 0, .length = 1};
	NSRange defaultGestureVectorRange = {.location = 1, .length = 10};

	[self trainWithFile:incomingFilePath
	      lineSeperator:[[NSString alloc] initWithFormat:@"%c", '\n']
	    elementSeperator:[[NSString alloc] initWithFormat:@","]
correspondingStringRange:defaultCorrespondingStringRange
	  gestureVectorRange:defaultGestureVectorRange
			  bufferSize:10];
}

- (void)trainWithFile:(NSString *)incomingFilePath
        lineSeperator:(NSString *)incomingLineSeperator
	    elementSeperator:(NSString *)incomingElementSeperator
correspondingStringRange:(NSRange)incomingCorrespondingStringRange
	  gestureVectorRange:(NSRange)incomingGestureVectorRange
			  bufferSize:(NSUInteger)incomingBufferSize
{
	NSError *errorReadingFromFile;
	NSStringEncoding encodingOfFile;
	NSString *incomingFile = [[NSString alloc] initWithContentsOfFile:[incomingFilePath stringByExpandingTildeInPath]
	                                                     usedEncoding:&encodingOfFile
				                                                error:&errorReadingFromFile];

	NSArray *linesOfIncomingFile = [[NSArray alloc] initWithArray:[incomingFile componentsSeparatedByString:incomingLineSeperator]];

	for (NSString *currentLine in linesOfIncomingFile)
	{
		if ((currentLine == linesOfIncomingFile.lastObject) && ([currentLine isEqualTo:[[NSString alloc]initWithFormat:@""]]))
		{
			break;
		}

		NSArray *seperatedElementsOfCurrentLine = [currentLine componentsSeparatedByString:incomingElementSeperator];

		NSMutableString *currentCorrespondingString = [[NSMutableString alloc]init];
		NSMutableArray *currentGestureVector = [[NSMutableArray alloc]init];

		for (NSString *partOfCorrespondingString in [seperatedElementsOfCurrentLine subarrayWithRange:incomingCorrespondingStringRange])
		{
			[currentCorrespondingString appendString:partOfCorrespondingString];
		}

		for (NSString *gestureVectorDimension in [seperatedElementsOfCurrentLine subarrayWithRange:incomingGestureVectorRange])
		{
			[currentGestureVector addObject:[[NSNumber alloc] initWithInteger:[gestureVectorDimension integerValue]]];
		}

		[self trainWithActionDefinition:[[AFActionDefinition alloc] initWithGestureVector:currentGestureVector
		                                                                        andBuffer:incomingBufferSize
				                                                                forString:currentCorrespondingString]];
	}
}

- (NSString *)recognizeWithBoundingboxMethod:(NSArray *)incomingGestureVector
{
	for (AFActionDefinition *currentActionDefinition in self.stack)
	{
		NSLog(@"trying to recognize with... : %@", currentActionDefinition);
		for (int i = 0; i < incomingGestureVector.count; i++)
		{
			NSUInteger currentIncomingDimension = [[incomingGestureVector objectAtIndex:i] integerValue];
			NSUInteger currentExistingUpperDimension = [[currentActionDefinition.upperBound objectAtIndex:i] integerValue];
			NSUInteger currentExistingLowerDimension = [[currentActionDefinition.lowerBound objectAtIndex:i] integerValue];

			if (currentIncomingDimension <= currentExistingUpperDimension && currentIncomingDimension >= currentExistingLowerDimension)
			{
				if ( i == incomingGestureVector.count - 1)
				{
					return currentActionDefinition.correspondingString;
				}
			}
			else
			{
				break;
			}
		}

	}
	return [[NSString alloc] initWithFormat:@"not recognized"];
}

- (NSError *)exportCurrentActionDefinitionStackWithStandardConfigurationTo:(NSString *)exportFilePath
{
	[self exportCurrentActionDefinitionStackTo:exportFilePath
	                             lineSeperator:[[NSString alloc] initWithFormat:@"%c", '\n']
				              elementSeperator:[[NSString alloc] initWithFormat:@","]];
    return nil;
}

- (NSError *)exportCurrentActionDefinitionStackTo:(NSString *)exportFilePath
                                    lineSeperator:(NSString *)incomingLineSeperator
			                     elementSeperator:(NSString *)incomingElementSeperator
{
	NSString *incomingExportFilePath = [exportFilePath stringByExpandingTildeInPath];

	NSMutableString *resultingStringToExport = [[NSMutableString alloc]init];

	BOOL atomicWriteDecision = YES;
	NSStringEncoding encoding = NSASCIIStringEncoding;
	NSError *resultingError;

	for (AFActionDefinition *currentActionDefinition in self.stack)
	{
		[resultingStringToExport appendString:currentActionDefinition.correspondingString];
		[resultingStringToExport appendString:incomingElementSeperator];

		for (int i = 0; i < currentActionDefinition.upperBound.count; i++)
		{
			NSString *currentDimensionString = [[currentActionDefinition.upperBound objectAtIndex:i] stringValue];

			[resultingStringToExport appendString:currentDimensionString];
			if (i != currentActionDefinition.upperBound.count-1)
			{
				[resultingStringToExport appendString:incomingElementSeperator];
			}
			else
			{
				[resultingStringToExport appendString:incomingLineSeperator];
			}
		}

		[resultingStringToExport appendString:currentActionDefinition.correspondingString];
		[resultingStringToExport appendString:incomingElementSeperator];

		for (int i = 0; i < currentActionDefinition.lowerBound.count; i++)
		{
			NSString *currentDimensionString = [[currentActionDefinition.lowerBound objectAtIndex:i] stringValue];

			[resultingStringToExport appendString:currentDimensionString];
			if (i != currentActionDefinition.lowerBound.count-1)
			{
				[resultingStringToExport appendString:incomingElementSeperator];
			}
			else
			{
				[resultingStringToExport appendString:incomingLineSeperator];
			}
		}

	}

	[resultingStringToExport writeToFile:incomingExportFilePath
	                          atomically:atomicWriteDecision
			                    encoding:encoding
					               error:&resultingError];

	return resultingError;
}


@end