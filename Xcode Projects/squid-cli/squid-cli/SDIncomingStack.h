//
//  SDIncomingStack.h
//  squid-cli
//
//  Created by Carl Dong on 6/25/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDRecognizer.h"

@interface SDIncomingStack : NSObject

@property NSMutableArray *gestureStack;
@property NSArray *pendingGesture;
@property (nonatomic) SDRecognizer *recognizer;

- (void)pushToPending: (NSArray *)incomingGestureVector;
- (void)push: (NSArray *)incomingGestureVector;

- (NSArray *)pop;
- (void)clearAll;


@end