//
//  SDDefinitionMutableArray.h
//  squid-cli
//
//  Created by Carl Dong on 6/26/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDActionDefinition.h"
#import <Foundation/Foundation.h>

@interface SDRecognizer : NSObject

@property (nonatomic) NSMutableArray *definitions;


- (void)addActionDefinition:(NSArray *)newDefinition
                        for:(NSString *)character;
- (NSString *)isAction:(NSArray *)input;


@end