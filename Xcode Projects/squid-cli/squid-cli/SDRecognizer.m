//
//  SDDefinitionMutableArray.m
//  squid-cli
//
//  Created by Carl Dong on 6/26/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDRecognizer.h"

@implementation SDRecognizer

@synthesize definitionStack = _definitionStack;

- (NSMutableArray *)definitionStack
{
    if (!_definitionStack)
    {
        _definitionStack = [[NSMutableArray alloc]init];
    }
    return _definitionStack;
}

- (SDRecognizer *)initWithActionDefinitions:(SDActionDefinition *)definition1, ...
{
    if (self = [super init])
    {
	    va_list args;
	    va_start(args, definition1);
	    [self addActionDefinitions:CFBridgingRelease(args), nil];
    }
    return self;
}

- (void)addGestureVector:(NSArray *)newDefinition
                        for:(NSString *)character
{
    
    NSString *newCharacter = [[NSString alloc] initWithString:character];
    NSNumber *bufferValue = [[NSNumber alloc]initWithInt:10];
    
    NSArray *newUpperBound = [self changeEachNSNumberInArray:newDefinition by:bufferValue deltaIsPositive:YES];
    NSArray *newLowerBound = [self changeEachNSNumberInArray:newDefinition by:bufferValue deltaIsPositive:NO];
    
    for (SDActionDefinition *actionDefinition in [self definitionStack])
    {
        
        if ([actionDefinition.correspondingCharacter isEqualTo:newCharacter])
        {
            for (int i = 0; i < [newDefinition count]; i++)
            {
                
                //Comparing upper bounds...
                NSNumber *existingUpperBoundAtI = [[actionDefinition upperBound] objectAtIndex:i];
                NSNumber *newUpperBoundAtI = [newUpperBound objectAtIndex:i];
                
                NSComparisonResult existingAndNewUpperBoundsComparisonResult = [existingUpperBoundAtI compare:newUpperBoundAtI];
                
                switch (existingAndNewUpperBoundsComparisonResult)
                {
                    case NSOrderedAscending:
                        existingUpperBoundAtI = newUpperBoundAtI;
                        break;
                        
                    case NSOrderedDescending:
                        break;
                        
                    default:
                        break;
                }
                
                //Comparing lower bounds...
                NSNumber *existingLowerBoundAtI = [[actionDefinition lowerBound] objectAtIndex:i];
                NSNumber *newLowerBoundAtI = [newLowerBound objectAtIndex:i];
                
                
                NSComparisonResult existingAndNewLowerBoundsComparisonResult = [existingLowerBoundAtI compare:newLowerBoundAtI];
                
                switch (existingAndNewLowerBoundsComparisonResult)
                {
                    case NSOrderedAscending:
                        break;
                        
                    case NSOrderedDescending:
                        existingLowerBoundAtI = newLowerBoundAtI;
                        break;
                        
                    default:
                        break;
                }
            }
            break;
            return;
        }
        
    }
    
    [self.definitionStack addObject:[[SDActionDefinition alloc] initWithUpperBound:newUpperBound andLowerBound:newLowerBound forCorrespondingString:newCharacter]];
    //NSLog(@"added definition for %@ with upperBound %@ and lower bound %@", newCharacter, newUpperBound, newLowerBound);
}

- (void)addActionDefinition:(SDActionDefinition *)actionDefinition
{
	[self.definitionStack addObject:actionDefinition];
}

- (void)addActionDefinitions:(SDActionDefinition *)definition1, ...
{

	va_list args;
	va_start(args, definition1);
	for (SDActionDefinition *arg = definition1; arg != nil; arg = va_arg(args, SDActionDefinition*))
	{
		[self addActionDefinition:arg];
	}
	va_end(args);
}


- (NSString *)isAction:(NSArray *)input
{
    //NSLog(@"operating isAction with upper %@ and lower %@", [self.definitions.lastObject upperBound], [self.definitions.lastObject lowerBound]);
    NSString *result = [[NSString alloc]init];

    if ([input count]!=[[self.definitionStack.lastObject upperBound] count])
    {
        NSLog(@"input has more dimensions than definition");
        return result;
    }
    
    
    for (SDActionDefinition *actionDefinition in [self definitionStack])
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
