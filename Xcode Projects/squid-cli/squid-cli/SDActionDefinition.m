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

- (SDActionDefinition *)initWithCorrespondingCharacter:(NSString *)character
                                            upperBound:(NSArray *)upper
                                            lowerBound:(NSArray *)lower
{
    SDActionDefinition *initializedResult = [[SDActionDefinition alloc]init];;
    initializedResult.correspondingCharacter = character;
    initializedResult.upperBound = upper;
    initializedResult.lowerBound = lower;
    return initializedResult;
}

@end
