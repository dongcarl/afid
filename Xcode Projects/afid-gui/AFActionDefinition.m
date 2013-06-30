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
        _upperBound = [[NSArray alloc]init];
    }
    return _upperBound;
}

- (NSArray *)lowerBound
{
    if(!_lowerBound)
    {
        _lowerBound = [[NSArray alloc]init];
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
		self.upperBound = incomingUpperBound;
		self.lowerBound = incomingLowerBound;
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
			currentExistingUpperBound = currentIncomingUpperBound;
		}
		if(currentIncomingLowerBound < currentExistingLowerBound)
		{
			currentExistingLowerBound = currentIncomingLowerBound;
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