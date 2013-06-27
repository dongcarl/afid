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
@synthesize recognizer = _recognizer;

- (SDRecognizer *)recognizer
{
    if(!_recognizer)
    {
        _recognizer = [[SDRecognizer alloc]init];
    }
    return _recognizer;
}

- (void)pushToPending: (NSString *)incomingGestureString
{
    //NSLog(@"reached pushToPending with gestuer string %@", incomingGestureString);
    
    NSArray *seperatedComponents = [incomingGestureString componentsSeparatedByString:@" "];
    //NSLog(@"seperatedComponents has %lu elements", (unsigned long)[seperatedComponents count]);
    //NSLog(@"this is being compared to... %@", [self.recognizer.definitions.lastObject upperBound]);
    
    if ([seperatedComponents count] != [[[self.recognizer.definitions lastObject]upperBound] count])
    {
        //NSLog(@"incoming array has more dimensions than definition!");

    }
    else
    {
        self.pendingGesture = seperatedComponents;
    }
//    NSLog(@"pushed to pendingGesture: %@", self.pendingGesture);
}

- (void)push: (NSString *)incomingGestureString
{    
    [self pushToPending:incomingGestureString];
    [self.gestureStack addObject:self.pendingGesture];
//    NSLog(@"pushed onto gestureStack: %@", self.pendingGesture);
    
    NSString *gestureRecognized = [[NSString alloc] initWithString:[self.recognizer isAction:self.pendingGesture]];
    NSLog(@"pushed gesture recognized as: %@", gestureRecognized);
    self.pendingGesture = nil;
}

- (NSArray *)pop
{
    NSArray *result = [[NSArray alloc] initWithArray:[self.gestureStack lastObject]];
    //NSLog(@"poped back: %@", result);
    return result;
}

- (void)clearAll
{
    self.gestureStack = nil;
    self.pendingGesture = nil;
    //NSLog(@"incomingStack cleared!");
}

@end
