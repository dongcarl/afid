//
//  AFRecognizer.m
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFRecognizer.h"

@implementation AFRecognizer

@synthesize bufferSize = _bufferSize;

@synthesize actionDefinitionStack = _actionDefinitionStack;

- (int)bufferSize
{
	if (!_bufferSize)
	{
		_bufferSize = 10;
	}
	return _bufferSize;
}

- (NSMutableArray *)actionDefinitionStack
{
	if (!_actionDefinitionStack)
	{
		_actionDefinitionStack = [[NSMutableArray alloc]init];
	}
	return _actionDefinitionStack;
}

//initializers
- (AFRecognizer *)initWithActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ...
{
	if (self = [super init])
	{
		va_list args;
		va_start(args, incomingActionDefinition1);
		for (AFActionDefinition *arg = incomingActionDefinition1; arg != nil; arg = va_arg(args, AFActionDefinition*))
		{
			[self addSingleActionDefinition:arg];
		}
		va_end(args);
	}
	return self;
}

- (AFRecognizer *)initWithSingleActionDefinition:(AFActionDefinition *)incomingActionDefition
{
	if (self = [super init])
	{
		[self addSingleActionDefinition:incomingActionDefition];
	}
	return self;
}

- (AFRecognizer *)initWithSingleGestureVector:(NSArray *)incomingGestureVector
                                    forString:(NSString *)incomingString
{
	if (self = [super init])
	{
		[self addGestureVector:incomingGestureVector forString:incomingString];
	}
	return self;
}

//adders
- (void)addActionDefinitions:(AFActionDefinition *)incomingActionDefinition1, ...
{
	va_list args;
	va_start(args, incomingActionDefinition1);
	for (AFActionDefinition *arg = incomingActionDefinition1; arg != nil; arg = va_arg(args, AFActionDefinition*))
	{
		[self addSingleActionDefinition:arg];
	}
	va_end(args);
}

- (void)addSingleActionDefinition:(AFActionDefinition *)incomingActionDefinition //key function
{
	BOOL existingActionDefinitionStackContainsIncomingActionDefinition = NO;
	AFActionDefinition *duplicateDefinitionInExistingActionDefinitionStack;
    
	for(AFActionDefinition *currentDefinition in self.actionDefinitionStack)
	{
		if([incomingActionDefinition.correspondingCharacter isEqualTo:currentDefinition.correspondingCharacter])
		{
			existingActionDefinitionStackContainsIncomingActionDefinition = YES;
			duplicateDefinitionInExistingActionDefinitionStack = currentDefinition;
			break;
		}
	}
    
	if (existingActionDefinitionStackContainsIncomingActionDefinition)
	{
		NSLog(@"going to modify %@ with %@", duplicateDefinitionInExistingActionDefinitionStack, incomingActionDefinition);
		[duplicateDefinitionInExistingActionDefinitionStack modifyBoundsWithActionDefinition:incomingActionDefinition];
	}
	else
	{
		[self.actionDefinitionStack addObject:incomingActionDefinition];
	}
}

- (void)addGestureVector:(NSArray *)incomingGestureVector
               forString:(NSString *)incomingString
{
	AFActionDefinition *incomingActionDefinition = [[AFActionDefinition alloc] initWithGestureVector:incomingGestureVector andBuffer:self.bufferSize forString:incomingString];
    
	[self addSingleActionDefinition:incomingActionDefinition];
}

- (NSString *)isAction:(NSArray *)input
{
    //	//NSLog(@"operating isAction with upper %@ and lower %@", [self.actionDefinitionStack.lastObject upperBound], [self.actionDefinitionStack.lastObject lowerBound]);
    //	NSString *result = [[NSString alloc]init];
    //
    //	if ([input count]!=[[self.actionDefinitionStack.lastObject upperBound] count])
    //	{
    //		NSLog(@"input has more dimensions than definition");
    //		return result;
    //	}
    //
    //
    //	for (AFActionDefinition *actionDefinition in [self actionDefinitionStack])
    //	{
    //
    //		BOOL outsideAnyBounds = NO;
    //
    //		for(int i = 0; i < [input count]; i++)
    //		{
    //			if(([[input objectAtIndex:i] intValue] > [[actionDefinition.upperBound objectAtIndex:i]intValue]) || ([[input objectAtIndex:i] intValue] < [[actionDefinition.lowerBound objectAtIndex:i]intValue]))
    //			{
    //				outsideAnyBounds = YES;
    //				break;
    //			}
    //		}
    //
    //		if (outsideAnyBounds == NO)
    //		{
    //			return actionDefinition.correspondingCharacter;
    //		}
    //	}
    //
    //	return result;
    
	int input1 = [[input objectAtIndex:0] intValue];
	int input2 = [[input objectAtIndex:1] intValue];
	int input3 = [[input objectAtIndex:2] intValue];
	int input4 = [[input objectAtIndex:3] intValue];
	int input5 = [[input objectAtIndex:4] intValue];
	int input6 = [[input objectAtIndex:5] intValue];
	int input7 = [[input objectAtIndex:6] intValue];
	int input8 = [[input objectAtIndex:7] intValue];
	int input9 = [[input objectAtIndex:8] intValue];
	int input10 = [[input objectAtIndex:9] intValue];
    
    if (input3 <= 770)
    {
        if (input5 >= 878)
        {
            if (input2 >= 832) {return [[NSString alloc]initWithFormat: @"D"];}
            else if (input2 <= 805)
            {
                if (input8 >= 861)
                {
                    if (input7 <= 870) {return [[NSString alloc]initWithFormat: @"P"];}
                    else if (input7 >= 876)
                    {
                        if (input1 <= 927) {return [[NSString alloc]initWithFormat: @"L"];}
                        else if (input1 >= 940) {return [[NSString alloc]initWithFormat: @"Q"];}
                    }
                }
                else if (input8 <= 859)
                {
                    if (input2 <= 787) {return [[NSString alloc]initWithFormat: @"L"];}
                    else if (input2 >= 789)
                    {
                        if (input8 >= 853) {return [[NSString alloc]initWithFormat: @"P"];}
                        else if (input8 <= 852)
                        {
                            if (input3 <= 727) {return [[NSString alloc]initWithFormat: @"L"];}
                            else if (input3 >= 728) {return [[NSString alloc]initWithFormat: @"G"];}
                        }
                    }
                }
            }
        }
        else if (input5 <= 857)
        {
            if (input10 <= 771)
            {
                if (input3 <= 743) {return [[NSString alloc]initWithFormat: @"B"];}
                else if (input3 >= 763) {return [[NSString alloc]initWithFormat: @"C"];}
            }
            else if (input10 >= 781)
            {
                if (input7 <= 864)
                {
                    if (input7 <= 753) {return [[NSString alloc]initWithFormat: @"W"];}
                    else if (input7 >= 828)
                    {
                        if (input6 >= 829) {return [[NSString alloc]initWithFormat: @"P"];}
                        else if (input6 <= 825)
                        {
                            if (input10 <= 802) {return [[NSString alloc]initWithFormat: @"H"];}
                            else if (input10 >= 808) {return [[NSString alloc]initWithFormat: @"K"];}
                        }
                    }
                }
                else if (input7 >= 876)
                {
                    if (input1 <= 926)
                    {
                        if (input2 <= 798) {return [[NSString alloc]initWithFormat: @"K"];}
                        else if (input2 >= 810)
                        {
                            if (input8 <= 838) {return [[NSString alloc]initWithFormat: @"H"];}
                            else if (input8 >= 840) {return [[NSString alloc]initWithFormat: @"U"];}
                        }
                    }
                    else if (input1 >= 927)
                    {
                        if (input2 <= 837)
                        {
                            if (input1 <= 936)
                            {
                                if (input4 <= 768) {return [[NSString alloc]initWithFormat: @"H"];}
                                else if (input4 >= 771) {return [[NSString alloc]initWithFormat: @"U"];}
                            }
                            else if (input1 >= 940)
                            {
                                if (input6 <= 791) {return [[NSString alloc]initWithFormat: @"U"];}
                                else if (input6 >= 792) {return [[NSString alloc]initWithFormat: @"R"];}
                            }
                        }
                        else if (input2 >= 840)
                        {
                            if (input8 <= 829)
                            {
                                if (input1 <= 942) {return [[NSString alloc]initWithFormat: @"U"];}
                                else if (input1 >= 943) {return [[NSString alloc]initWithFormat: @"V"];}
                            }
                            else if (input8 >= 833)
                            {
                                if (input6 <= 793)
                                {
                                    if (input10 <= 792) {return [[NSString alloc]initWithFormat: @"U"];}
                                    else if (input10 >= 795) {return [[NSString alloc]initWithFormat: @"V"];}
                                }
                                else if (input6 >= 795)
                                {
                                    if (input4 <= 767) {return [[NSString alloc]initWithFormat: @"H"];}
                                    else if (input4 >= 775) {return [[NSString alloc]initWithFormat: @"U"];}
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    else if(input3 >= 787)
    {
        if (input8 <= 818)
        {
            if (input7 <= 748) {return [[NSString alloc]initWithFormat: @"F"];}
            else if (input7 >= 790)
            {
                if (input3 >= 874)
                {
                    if (input4 >= 821) {return [[NSString alloc]initWithFormat: @"I"];}
                    else if (input4 <= 812)
                    {
                        if (input2 <= 875) {return [[NSString alloc]initWithFormat: @"E"];}
                        else if (input2 >= 890) {return [[NSString alloc]initWithFormat: @"O"];}
                    }
                }
                else if (input3 <= 873)
                {
                    if (input10 >= 798) {return [[NSString alloc]initWithFormat: @"M"];}
                    else if (input10 <= 787)
                    {
                        if (input5 >= 900) {return [[NSString alloc]initWithFormat: @"I"];}
                        else if (input5 <= 896)
                        {
                            if (input1 <= 886) {return [[NSString alloc]initWithFormat: @"C"];}
                            else if (input1 >= 889)
                            {
                                if (input8 <= 782) {return [[NSString alloc]initWithFormat: @"C"];}
                                else if (input8 >= 790) {return [[NSString alloc]initWithFormat: @"O"];}
                            }
                        }
                    }
                }
            }
        }
        else if (input8 >= 824)
        {
            if (input2 >= 851)
            {
                if (input4 <= 801)
                {
                    if (input6 <= 811) {return [[NSString alloc]initWithFormat: @"O"];}
                    else if (input6 >= 819) {return [[NSString alloc]initWithFormat: @"X"];}
                }
                else if (input4 >= 817)
                {
                    if (input9 <= 856) {return [[NSString alloc]initWithFormat: @"M"];}
                    else if (input9 >= 879) {return [[NSString alloc]initWithFormat: @"S"];}
                }
            }
            else if (input2 <= 850)
            {
                if (input9 <= 857)
                {
                    if (input5 >= 887)
                    {
                        if (input2 <= 789) {return [[NSString alloc]initWithFormat: @"Y"];}
                        else if (input2 >= 793)
                        {
                            if (input1 <= 923) {return [[NSString alloc]initWithFormat: @"I"];}
                            else if (input1 >= 924) {return [[NSString alloc]initWithFormat: @"M"];}
                        }
                    }
                    else if (input5 <= 880)
                    {
                        if (input4 >= 835)
                        {
                            if (input2 <= 810) {return [[NSString alloc]initWithFormat: @"N"];}
                            else if (input2 >= 811) {return [[NSString alloc]initWithFormat: @"M"];}
                        }
                        else if (input4 <= 832)
                        {
                            if (input6 >= 828) {return [[NSString alloc]initWithFormat: @"T"];}
                            else if (input6 <= 826)
                            {
                                if (input8 <= 827) {return [[NSString alloc]initWithFormat: @"O"];}
                                else if (input8 >= 831) {return [[NSString alloc]initWithFormat: @"N"];}
                            }
                        }
                    }
                }
                else if (input9 >= 872)
                {
                    if (input2 >= 814)
                    {
                        if (input5 <= 891) {return [[NSString alloc]initWithFormat: @"M"];}
                        else if (input5 >= 897)
                        {
                            if (input9 <= 895) {return [[NSString alloc]initWithFormat: @"A"];}
                            else if (input9 >= 898) {return [[NSString alloc]initWithFormat: @"S"];}
                        }
                    }
                    else if (input2 <= 811)
                    {
                        if (input4 <= 819)
                        {
                            if (input3 <= 869) {return [[NSString alloc]initWithFormat: @"T"];}
                            else if (input3 >= 872)
                            {
                                if (input6 <= 802) {return [[NSString alloc]initWithFormat: @"T"];}
                                else if (input6 >= 811)
                                {
                                    if (input7 <= 862) {return [[NSString alloc]initWithFormat: @"T"];}
                                    else if (input7 >= 870) {return [[NSString alloc]initWithFormat: @"A"];}
                                }
                            }
                        }
                        else if (input4 >= 822)
                        {
                            if (input6 <= 815) {return [[NSString alloc]initWithFormat: @"N"];}
                            else if (input6 >= 817)
                            {
                                if (input3 <= 846) {return [[NSString alloc]initWithFormat: @"T"];}
                                else if (input3 >= 850)
                                {
                                    if (input10 <= 795) {return [[NSString alloc]initWithFormat: @"S"];}
                                    else if (input10 >= 796) {return [[NSString alloc]initWithFormat: @"A"];}
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    return [[NSString alloc] initWithFormat:@"none!"];
}


- (NSArray *)changeEachNSNumberInArray:(NSArray *)input
                                    by:(NSNumber *)delta
                       deltaIsPositive:(BOOL)deltaIsPositive
{
	NSMutableArray *result = [[NSMutableArray alloc]init];
    
	for (NSNumber *currentNumber in input)
	{
		if (deltaIsPositive)
		{
			[result addObject:[[NSNumber alloc]initWithInteger:([currentNumber intValue] + [delta intValue])]];
		}
		else
		{
			[result addObject:[[NSNumber alloc]initWithInteger:([currentNumber intValue] - [delta intValue])]];
		}
	}
    
	return result;
}

@end