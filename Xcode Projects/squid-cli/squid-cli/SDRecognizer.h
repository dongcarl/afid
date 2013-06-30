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

@property (nonatomic) NSMutableArray *definitionStack;

//initializers...
- (SDRecognizer *)initWithActionDefinitions:(SDActionDefinition *)definition1, ... NS_REQUIRES_NIL_TERMINATION;
//- (SDRecognizer *)initWithGestureVector:(NSArray *)gestureVector1, ... NS_REQUIRES_NIL_TERMINATION
//                forStrings:(NSString *)string1, ... NS_REQUIRES_NIL_TERMINATION;

//adding single action definitions
- (void)addGestureVector:(NSArray *)GestureVector
                     for:(NSString *)character;
- (void)addActionDefinition:(SDActionDefinition *)actionDefinition;

//adding multiple action definitions
- (void)addActionDefinitions:(SDActionDefinition *)definition1, ... NS_REQUIRES_NIL_TERMINATION;





- (NSString *)isAction:(NSArray *)input;


@end