//
//  AFRecognizer.m
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFRecognizer.h"

@implementation AFRecognizer

@synthesize bufferSize = _bufferSize;

@synthesize actionDefinitionStack = _actionDefinitionStack;

- (int)bufferSize
{
	if (!_bufferSize)
	{
		_bufferSize = 10;
	}
	return _bufferSize;
}

- (NSMutableArray *)actionDefinitionStack
{
	if (!_actionDefinitionStack)
	{
		_actionDefinitionStack = [[NSMutableArray alloc]init];
	}
	return _actionDefinitionStack;
}

//initializers
- (AFRecognizer *)initWithActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ...
{
	if (self = [super init])
	{
		va_list args;
		va_start(args, incomingActionDefinition1);
		for (AFActionDefinition *arg = incomingActionDefinition1; arg != nil; arg = va_arg(args, AFActionDefinition*))
		{
			[self addSingleActionDefinition:arg];
		}
		va_end(args);
	}
	return self;
}

- (AFRecognizer *)initWithSingleActionDefinition:(AFActionDefinition *)incomingActionDefition
{
	if (self = [super init])
	{
		[self addSingleActionDefinition:incomingActionDefition];
	}
	return self;
}

- (AFRecognizer *)initWithSingleGestureVector:(NSArray *)incomingGestureVector
                                    forString:(NSString *)incomingString
{
	if (self = [super init])
	{
		[self addGestureVector:incomingGestureVector forString:incomingString];
	}
	return self;
}

//adders
- (void)addActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ...
{
	va_list args;
	va_start(args, incomingActionDefinition1);
	for (AFActionDefinition *arg = incomingActionDefinition1; arg != nil; arg = va_arg(args, AFActionDefinition*))
	{
		[self addSingleActionDefinition:arg];
	}
	va_end(args);
}

- (void)addSingleActionDefinition:(AFActionDefinition *)incomingActionDefinition //key function
{
	BOOL existingActionDefinitionStackContainsIncomingActionDefinition = NO;
	AFActionDefinition *duplicateDefinitionInExistingActionDefinitionStack;

	for(AFActionDefinition *currentDefinition in self.actionDefinitionStack)
	{
		if([incomingActionDefinition.correspondingCharacter isEqualTo:currentDefinition.correspondingCharacter])
		{
			existingActionDefinitionStackContainsIncomingActionDefinition = YES;
			duplicateDefinitionInExistingActionDefinitionStack = currentDefinition;
			break;
		}
	}

	if (existingActionDefinitionStackContainsIncomingActionDefinition)
	{
		NSLog(@"going to modify %@ with %@", duplicateDefinitionInExistingActionDefinitionStack, incomingActionDefinition);
		[duplicateDefinitionInExistingActionDefinitionStack modifyBoundsWithActionDefinition:incomingActionDefinition];
	}
	else
	{
		[self.actionDefinitionStack addObject:incomingActionDefinition];
	}
}

- (void)addGestureVector:(NSArray *)incomingGestureVector
               forString:(NSString *)incomingString
{
	AFActionDefinition *incomingActionDefinition = [[AFActionDefinition alloc] initWithGestureVector:incomingGestureVector andBuffer:self.bufferSize forString:incomingString];

	[self addSingleActionDefinition:incomingActionDefinition];
}

- (NSString *)isAction:(NSArray *)input
{
	//NSLog(@"operating isAction with upper %@ and lower %@", [self.actionDefinitionStack.lastObject upperBound], [self.actionDefinitionStack.lastObject lowerBound]);
	NSString *result = [[NSString alloc]init];

	if ([input count]!=[[self.actionDefinitionStack.lastObject upperBound] count])
	{
		NSLog(@"input has more dimensions than definition");
		return result;
	}


	for (AFActionDefinition *actionDefinition in [self actionDefinitionStack])
	{

		BOOL outsideAnyBounds = NO;

		for(int i = 0; i < [input count]; i++)
		{
			if(([[input objectAtIndex:i] intValue] > [[actionDefinition.upperBound objectAtIndex:i]intValue]) || ([[input objectAtIndex:i] intValue] < [[actionDefinition.lowerBound objectAtIndex:i]intValue]))
			{
				outsideAnyBounds = YES;
				break;
			}
		}

		if (outsideAnyBounds == NO)
		{
			return actionDefinition.correspondingCharacter;
		}
	}

	return result;
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