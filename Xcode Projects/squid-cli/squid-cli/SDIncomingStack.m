//
//  SDIncomingStack.m
//  squid-cli
//
//  Created by Carl Dong on 6/25/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDIncomingStack.h"

@implementation SDIncomingStack

@synthesize gestureStack = _gestureStack;
@synthesize pendingGesture = _pendingGesture;

- (void)pushToPending: (NSString *)incomingGestureString
{
    NSArray *seperatedComponents = [incomingGestureString componentsSeparatedByString:@"  "];
    self.pendingGesture = [[NSMutableArray alloc] initWithArray:seperatedComponents copyItems:YES];
    NSLog(@"pushed to pendingGesture: %@", self.pendingGesture);
}

- (void)push: (NSString *)incomingGestureString
{
    [self pushToPending:incomingGestureString];
    [self.gestureStack addObject:self.pendingGesture];
    NSLog(@"pushed onto gestureStack: %@", self.pendingGesture);
    self.pendingGesture = nil;
}

- (NSArray *)pop
{
    NSArray *result = [[NSArray alloc] initWithArray:[self.gestureStack lastObject]];
    NSLog(@"poped back: %@", result);
    return result;
}

- (void)clearAll
{
    self.gestureStack = nil;
    self.pendingGesture = nil;
    NSLog(@"incomingStack cleared!");
}

@end
