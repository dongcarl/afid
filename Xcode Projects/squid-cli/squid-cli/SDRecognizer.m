//
//  SDDefinitionMutableArray.m
//  squid-cli
//
//  Created by Carl Dong on 6/26/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDRecognizer.h"

@implementation SDRecognizer

@synthesize definitions = _definitions;

- (NSMutableArray *)definitions
{
    if (!_definitions)
    {
        _definitions = [[NSMutableArray alloc]init];
    }
    return _definitions;
}

- (void)addActionDefinition:(NSArray *)newDefinition
                        for:(NSString *)character
{
    
    NSString *newCharacter = [[NSString alloc] initWithString:character];
    NSNumber *bufferValue = [[NSNumber alloc]initWithInt:30];
    
    NSArray *newUpperBound = [self changeEachNSNumberInArray:newDefinition by:bufferValue deltaIsPositive:YES];
    NSArray *newLowerBound = [self changeEachNSNumberInArray:newDefinition by:bufferValue deltaIsPositive:NO];
    
    for (SDActionDefinition *actionDefinition in [self definitions])
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
    
    [self.definitions addObject:[[SDActionDefinition alloc] initWithCorrespondingCharacter:newCharacter upperBound:newUpperBound lowerBound:newLowerBound]];
    //NSLog(@"added definition for %@ with upperBound %@ and lower bound %@", newCharacter, newUpperBound, newLowerBound);
    
}

- (NSString *)isAction:(NSArray *)input
{
    //NSLog(@"operating isAction with upper %@ and lower %@", [self.definitions.lastObject upperBound], [self.definitions.lastObject lowerBound]);
    
    NSString *result = [[NSString alloc]init];
    
    for (SDActionDefinition *actionDefinition in [self definitions])
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
