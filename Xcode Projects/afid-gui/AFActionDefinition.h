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
@property (nonatomic) BOOL hasModifiedUpperBound;
@property (nonatomic) BOOL hasModifiedLowerBound;
@property (nonatomic) NSMutableArray *gestureVector;
@property (nonatomic) NSUInteger bufferSize;
@property (nonatomic) NSMutableString *correspondingString;

//initializers
- (AFActionDefinition *)initWithGestureVector:(NSArray *)incomingGestureVector
                                    andBuffer:(NSUInteger)incomingBufferValue
		                            forString:(NSString *)incomingString;
- (AFActionDefinition *)initWithActionDefinition:(AFActionDefinition *)incomingActionDefinition;

//modifiers
- (void)modifyBoundsWithGestureVector:(NSArray *)incomingGestureVector;
- (void)modifyBoundsWithActionDefinition:(AFActionDefinition *)incomingActionDefinition;

@end