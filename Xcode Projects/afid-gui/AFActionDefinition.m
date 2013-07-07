//
//  AFActionDefinition.m
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFActionDefinition.h"

@implementation AFActionDefinition

@synthesize upperBound = _upperBound;
@synthesize lowerBound = _lowerBound;
@synthesize hasModifiedUpperBound = _hasModifiedUpperBound;
@synthesize hasModifiedLowerBound = _hasModifiedLowerBound;
@synthesize bufferSize = _bufferSize;
@synthesize gestureVector = _gestureVector;
@synthesize correspondingString = _correspondingString;

- (NSMutableArray *)upperBound
{
	if (!_upperBound)
	{
		_upperBound = [[NSMutableArray alloc] initWithArray:[self changeEachNSNumberInArray:_gestureVector
		                                                                   by:_bufferSize
		                                                      deltaIsPositive:YES]];
	}
	return _upperBound;
}
- (NSMutableArray *)lowerBound
{
	if (!_lowerBound)
	{
		_lowerBound = [[NSMutableArray alloc] initWithArray:[self changeEachNSNumberInArray:_gestureVector
		                                                                          by:_bufferSize
		                                                             deltaIsPositive:NO]];
	}
	return _lowerBound;
}
- (BOOL)hasModifiedUpperBound
{
	if (!_hasModifiedUpperBound)
	{
		_hasModifiedUpperBound = NO;
	}
	return _hasModifiedUpperBound;
}
- (BOOL)hasModifiedLowerBound
{
	if (!_hasModifiedLowerBound)
	{
		_hasModifiedLowerBound = NO;
	}
	return _hasModifiedLowerBound;
}
- (NSMutableArray *)gestureVector
{
	if (!_gestureVector)
	{
			_gestureVector = [[NSMutableArray alloc]init];
	}
	return _gestureVector;
}
- (NSMutableString *)correspondingString
{
	if(!_correspondingString)
	{
		_correspondingString = [[NSMutableString alloc]init];
	}
	return _correspondingString;
}
- (NSUInteger)numberOfDimensions
{
	return self.gestureVector.count;
}

//initializers
- (AFActionDefinition *)initWithActionDefinition:(AFActionDefinition *)incomingActionDefinition
{
	if (self = [super init])
	{
		self = incomingActionDefinition;
	}
	return self;
}
- (AFActionDefinition *)initWithGestureVector:(NSArray *)incomingGestureVector
                                    andBuffer:(NSUInteger)incomingBufferValue
		                            forString:(NSString *)incomingString
{
	if (self = [super init])
	{
		self.gestureVector = [[NSMutableArray alloc] initWithArray:incomingGestureVector copyItems:YES];
		self.bufferSize = incomingBufferValue;
		self.correspondingString = [incomingString mutableCopy];
	}
	return self;
}

//modifiers
- (void)modifyBoundsWithActionDefinition:(AFActionDefinition *)incomingActionDefinition
{
	NSArray *incomingUpperBound = incomingActionDefinition.upperBound;
	NSArray *incomingLowerBound = incomingActionDefinition.lowerBound;

	for (int i = 0; i < self.numberOfDimensions; i++)
	{
		if ([[incomingUpperBound objectAtIndex:i] integerValue] > [[self.upperBound objectAtIndex:i] integerValue])
		{
			[self.upperBound replaceObjectAtIndex:i withObject:[incomingUpperBound objectAtIndex:i]];
			self.hasModifiedUpperBound = YES;
		}
		if ([[incomingLowerBound objectAtIndex:i] integerValue] < [[self.lowerBound objectAtIndex:i] integerValue])
		{
			[self.lowerBound replaceObjectAtIndex:i withObject:[incomingLowerBound objectAtIndex:i]];
			self.hasModifiedLowerBound = YES;
		}
	}
}
- (void)modifyBoundsWithGestureVector:(NSArray *)incomingGestureVector
{
	AFActionDefinition *incomingActionDefinition = [[AFActionDefinition alloc] initWithGestureVector:incomingGestureVector
	                                                                                       andBuffer:self.bufferSize
			                                                                               forString:self.correspondingString];
	[self modifyBoundsWithActionDefinition:incomingActionDefinition];
}

//helper class
- (NSArray *)changeEachNSNumberInArray:(NSArray *)input
                                    by:(NSUInteger)delta
                       deltaIsPositive:(BOOL)deltaIsPositive
{
	NSMutableArray *result = [[NSMutableArray alloc]init];

	for (NSNumber *currentNumber in input)
	{
		if (deltaIsPositive)
		{
			[result addObject:[[NSNumber alloc]initWithInteger:([currentNumber intValue] + delta)]];
		}
		else
		{
			[result addObject:[[NSNumber alloc]initWithInteger:([currentNumber intValue] - delta)]];
		}
	}

	return result;
}

//NSLog
- (NSString *)description
{
	NSMutableString *upperBound = [[NSMutableString alloc]init];
	for (id i in self.upperBound)
	{
		[upperBound appendFormat:@"%@", i];
		if (![i isEqualTo:self.upperBound.lastObject])
		{
			[upperBound appendFormat:@" "];
		}
	}

	NSMutableString *lowerBound = [[NSMutableString alloc]init];
	for (NSObject *i in self.lowerBound)
	{
		[lowerBound appendFormat:@"%@", i];
		if (![i isEqualTo:self.lowerBound.lastObject])
		{
			[lowerBound appendFormat:@" "];
		}
	}

	return [[NSString alloc] initWithFormat:@"\nlogging an AFActionDefinition with \n"
			                                        "upperBound: %@\n"
			                                        "lowerBound: %@\n"
			                                        "correspondingString %@", upperBound, lowerBound,
	                                        self.correspondingString];
}

@end