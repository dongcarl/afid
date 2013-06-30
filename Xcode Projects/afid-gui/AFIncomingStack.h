//
//  AFIncomingStack.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFRecognizer.h"
#import <Foundation/Foundation.h>

@interface AFIncomingStack : NSObject

@property NSMutableArray *gestureStack;
@property NSArray *pendingGesture;
@property (nonatomic) AFRecognizer *recognizer;

- (void)pushToPending: (NSArray *)incomingGestureVector;
- (void)push: (NSArray *)incomingGestureVector;

- (NSArray *)popFromPending;
- (NSArray *)pop;

- (void)clearAll;

@end
