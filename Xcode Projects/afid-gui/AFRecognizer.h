//
//  AFRecognizer.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFActionDefinition.h"
#import <Foundation/Foundation.h>

@interface AFRecognizer : NSObject

@property (nonatomic) int bufferSize;

@property (nonatomic) NSMutableArray *actionDefinitionStack;

//initializers...
- (AFRecognizer *)initWithActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ... NS_REQUIRES_NIL_TERMINATION;
- (AFRecognizer *)initWithSingleActionDefinition:(AFActionDefinition *)incomingActionDefition;
- (AFRecognizer *)initWithSingleGestureVector:(NSArray *)incomingGestureVector
                                    forString:(NSString *)incomingString;

//adders...
- (void)addActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ... NS_REQUIRES_NIL_TERMINATION;
- (void)addSingleActionDefinition:(AFActionDefinition *)incomingActionDefinition;
- (void)addGestureVector:(NSArray *)incomingGestureVector
               forString:(NSString *)incomingString;

- (NSString *)isAction:(NSArray *)input;

@end