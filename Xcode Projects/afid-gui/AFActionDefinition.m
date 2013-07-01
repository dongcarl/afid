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

@synthesize correspondingCharacter = _correspondingCharacter;

- (NSArray *)upperBound
{
	if(!_upperBound)
	{
		_upperBound = [[NSMutableArray alloc]init];
	}
	return _upperBound;
}

- (NSArray *)lowerBound
{
	if(!_lowerBound)
	{
		_lowerBound = [[NSMutableArray alloc]init];
	}
	return _lowerBound;
}

- (NSString *)correspondingCharacter
{
	if(!_correspondingCharacter)
	{
		_correspondingCharacter = [[NSString alloc]init];
	}
	return _correspondingCharacter;
}

- (AFActionDefinition *)initWithUpperBound:(NSArray *)incomingUpperBound
                             andLowerBound:(NSArray *)incomingLowerBound
			        forCorrespondingString:(NSString *)incomingString
{
	if (self = [super init])
	{
		self.correspondingCharacter = incomingString;
		self.upperBound = [incomingUpperBound mutableCopy];
		self.lowerBound = [incomingLowerBound mutableCopy];
	}
	return self;
}

- (AFActionDefinition *)initWithActionDefinition:(AFActionDefinition *)incomingActionDefinition
{
	NSArray *incomingUpperBound = incomingActionDefinition.upperBound;
	NSArray *incomingLowerBound = incomingActionDefinition.lowerBound;
	NSString *incomingString = incomingActionDefinition.correspondingCharacter;

	return [self initWithUpperBound:incomingUpperBound andLowerBound:incomingLowerBound forCorrespondingString:incomingString];
}





- (AFActionDefinition *)initWithGestureVector:(NSArray *)incomingGestureVector
                                    andBuffer:(int)incomingBufferValue
		                            forString:(NSString *)incomingString
{
	NSArray *incomingUpperBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:incomingGestureVector copyItems:YES] by:incomingBufferValue deltaIsPositive:YES];
	NSArray *incomingLowerBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:incomingGestureVector copyItems:YES] by:incomingBufferValue deltaIsPositive:NO];

	return [self initWithUpperBound:incomingUpperBound andLowerBound:incomingLowerBound forCorrespondingString:incomingString];
}

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
			                                        "correspondingCharacter %@", upperBound, lowerBound, self.correspondingCharacter];
}

- (void)modifyBoundsWithUpperBound:(NSArray *)incomingUpperBound
                     andLowerBound:(NSArray *)incomingLowerBound
{
	for(int i = 0; i < [self.upperBound count]; i++)
	{
		NSNumber *currentExistingUpperBound = [self.upperBound objectAtIndex:i];
		NSNumber *currentExistingLowerBound = [self.lowerBound objectAtIndex:i];
		NSNumber *currentIncomingUpperBound = [incomingUpperBound objectAtIndex:i];
		NSNumber *currentIncomingLowerBound = [incomingLowerBound objectAtIndex:i];

		if(currentIncomingUpperBound > currentExistingUpperBound)
		{
			[self.upperBound replaceObjectAtIndex:i withObject:currentIncomingUpperBound];
		}
		if(currentIncomingLowerBound < currentExistingLowerBound)
		{
			[self.lowerBound replaceObjectAtIndex:i withObject:currentIncomingLowerBound];
		}
	}
}

- (void)modifyBoundsWithActionDefinition:(AFActionDefinition *)incomingActionDefinition
{
	NSArray *incomingUpperBound = incomingActionDefinition.upperBound;
	NSArray *incomingLowerBound = incomingActionDefinition.lowerBound;

	[self modifyBoundsWithUpperBound:incomingUpperBound
	                   andLowerBound:incomingLowerBound];
}

- (void)modifyBoundsWithGestureVector:(NSArray *)incomingGestureVector
                            andBuffer:(int)incomingBufferValue
{
	NSArray *incomingUpperBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:incomingGestureVector copyItems:YES] by:incomingBufferValue deltaIsPositive:YES];
	NSArray *incomingLowerBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:incomingGestureVector copyItems:YES] by:incomingBufferValue deltaIsPositive:NO];

	[self modifyBoundsWithUpperBound:incomingUpperBound
	                   andLowerBound:incomingLowerBound];
}

- (NSArray *)changeEachNSNumberInArray:(NSArray *)input
                                    by:(int)delta
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

@end