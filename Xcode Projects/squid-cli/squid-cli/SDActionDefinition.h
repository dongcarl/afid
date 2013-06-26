//
//  SDActionDefinition.h
//  squid-cli
//
//  Created by Carl Dong on 6/26/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDActionDefinition : NSObject

@property NSArray *upperBound;
@property NSArray *lowerBound;

@property NSString *correspondingCharacter;


- (SDActionDefinition *)initWithCorrespondingCharacter:(NSString *)character
                                            upperBound:(NSArray *)upper
                                            lowerBound:(NSArray *)lower;

@end
