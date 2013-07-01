//
//  AFActionDefinition.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFActionDefinition : NSObject

@property (nonatomic) NSMutableArray *upperBound;
@property (nonatomic) NSMutableArray *lowerBound;

@property (nonatomic) NSString *correspondingCharacter;



- (AFActionDefinition *)initWithGestureVector:(NSArray *)incomingGestureVector
                                    andBuffer:(int)incomingBufferValue
		                            forString:(NSString *)incomingString;
- (AFActionDefinition *)initWithActionDefinition:(AFActionDefinition *)incomingActionDefinition;
- (AFActionDefinition *)initWithUpperBound:(NSArray *)incomingUpperBound
                             andLowerBound:(NSArray *)incomingLowerBound
			        forCorrespondingString:(NSString *)incomingString;


- (void)modifyBoundsWithGestureVector:(NSArray *)incomingGestureVector
                            andBuffer:(int)incomingBufferValue;
- (void)modifyBoundsWithActionDefinition:(AFActionDefinition *)incomingActionDefinition;
- (void)modifyBoundsWithUpperBound:(NSArray *)incomingUpperBound
                     andLowerBound:(NSArray *)incomingLowerBound;

@end