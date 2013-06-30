//
//  SDActionDefinition.m
//  squid-cli
//
//  Created by Carl Dong on 6/26/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDActionDefinition.h"

@implementation SDActionDefinition

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

- (SDActionDefinition *)initWithUpperBound:(NSArray *)upper
                             andLowerBound:(NSArray *)lower
			        forCorrespondingString:(NSString *)string
{
	if (self = [super init])
	{
		self.correspondingCharacter = string;
		self.upperBound = upper;
		self.lowerBound = lower;
	}
    return self;
}

- (void)modifyBoundsWithGestureVector:(NSArray *)gestureVector
							andBuffer:(NSNumber *)buffer
{
	NSArray *incomingUpperBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:gestureVector copyItems:YES] by:buffer deltaIsPositive:YES];
	NSArray *incomingLowerBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:gestureVector copyItems:YES] by:buffer deltaIsPositive:NO];

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


- (SDActionDefinition *)initWithGestureVector:(NSArray *)gestureVector
									andBuffer:(NSNumber *)buffer
                                    forString:(NSString *)string
{
	if(self = [super init])
	{
		self.upperBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:gestureVector copyItems:YES] by:buffer deltaIsPositive:YES];
		self.lowerBound = [self changeEachNSNumberInArray:[[NSArray alloc] initWithArray:gestureVector copyItems:YES] by:buffer deltaIsPositive:NO];
		self.correspondingCharacter = string;
	}
	return self;
}



- (NSArray *)changeEachNSNumberInArray:(NSArray *)input
                                    by:(NSNumber *)delta
                       deltaIsPositive:(BOOL)deltaIsPositive
{
	NSMutableArray *result = [[NSMutableArray alloc]init];

	for (NSNumber *currentNumber in input)
	{
		if (deltaIsPositive)
		{
			[result addObject:[[NSNumber alloc]initWithInteger:([currentNumber intValue] + [delta intValue])]];
		}
		else
		{
			[result addObject:[[NSNumber alloc]initWithInteger:([currentNumber intValue] - [delta intValue])]];
		}
	}

	return result;
}


@end
