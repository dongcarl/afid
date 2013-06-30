//
//  SDActionDefinition.h
//  squid-cli
//
//  Created by Carl Dong on 6/26/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDActionDefinition : NSObject

@property (nonatomic) NSArray *upperBound;
@property (nonatomic) NSArray *lowerBound;

@property (nonatomic) NSString *correspondingCharacter;


- (SDActionDefinition *)initWithUpperBound:(NSArray *)upper
                             andLowerBound:(NSArray *)lower
			        forCorrespondingString:(NSString *)string;
- (SDActionDefinition *)initWithGestureVector:(NSArray *)gestureVector
									forString:(NSString *)string;


- (void)modifyBoundsWithGestureVector:(NSArray *)gestureVector;
@end