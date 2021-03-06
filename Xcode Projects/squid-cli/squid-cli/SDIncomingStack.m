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

- (void)pushToPending: (NSArray *)incomingGestureVector
{
	if ([incomingGestureVector count] != [[[self.recognizer.definitionStack lastObject]upperBound] count])
	{
		//NSLog(@"incoming array has more dimensions than definition!");

	}
	else
	{
		self.pendingGesture = incomingGestureVector;
	}
}

- (void)push:(NSArray *)incomingGestureVector
{
	[self pushToPending:incomingGestureVector];
	[self.gestureStack addObject:self.pendingGesture];

	self.pendingGesture = nil;
}

- (NSArray *)pop
{
    NSArray *result = [[NSArray alloc] initWithArray:self.gestureStack copyItems:YES];
	[self.gestureStack removeLastObject];
    return result;
}

- (void)clearAll
{
    self.gestureStack = [[NSMutableArray alloc]init];
    self.pendingGesture = [[NSArray alloc]init];
}

@end