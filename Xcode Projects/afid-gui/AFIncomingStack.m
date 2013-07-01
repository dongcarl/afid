//
//  AFIncomingStack.m
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFRecognizer.h"
#import "AFIncomingStack.h"

@implementation AFIncomingStack

@synthesize gestureStack = _gestureStack;
@synthesize pendingGesture = _pendingGesture;
@synthesize recognizer = _recognizer;

- (AFRecognizer *)recognizer
{
	if(!_recognizer)
	{
		_recognizer = [[AFRecognizer alloc]init];
	}
	return _recognizer;
}

- (void)pushToPending: (NSArray *)incomingGestureVector
{
	if ([incomingGestureVector count] != [[[self.recognizer.actionDefinitionStack lastObject]upperBound] count])
	{
		//NSLog(@"incoming array has more dimensions than definition!");

	}
	else
	{
		self.pendingGesture = incomingGestureVector;
	}
}

- (void)push: (NSArray *)incomingGestureVector
{
	[self pushToPending:incomingGestureVector];
	[self.gestureStack addObject:self.pendingGesture];

	self.pendingGesture = nil;
}

- (NSArray *)popFromPending
{
	NSArray *result = self.pendingGesture;
	self.pendingGesture = nil;
	return result;
}

- (NSArray *)pop
{
	NSArray *result = [[NSArray alloc] initWithArray:self.gestureStack copyItems:YES];
	[self.gestureStack removeLastObject];
	return result;
}

- (void)clearAll
{
	self.gestureStack = nil;
	self.pendingGesture = nil;
}

@end
