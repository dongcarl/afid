//
//  main.m
//  squid-cli
//
//  Created by Carl Dong on 6/22/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDSerialCommunicator.h"
#import "SDRecognizer.h"

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    
	@autoreleasepool
	{
		speed_t baud = B9600;
		SDSerialCommunicator *comm = [[SDSerialCommunicator alloc]init];
		[comm autoTrySerialPortWithBaudRate:baud];
		SDRecognizer *recognizer = [[SDRecognizer alloc] init];
        
		BOOL continueAddingGestures = NO;       
        
		do
		{
			NSLog(@"Enter the string you want to assign to the next gesture...");
            
            
            
			NSString *userInput = [[NSString alloc]init];
			SDActionDefinition *action = [comm actionDefinitionFromNext:25 linesForString:userInput];
            
			NSLog(@"Do you want to continue refining the gesture definition? [y/n]");
            
			char word2[40];
			int nChars2 = scanf("%39s", word2);
			NSString *userInput2 = [[NSString alloc] initWithBytes:word2 length:nChars2 encoding:NSASCIIStringEncoding];
			if([userInput2 isEqualToString:@"y"] || [userInput2 isEqualToString:@"Y"])
			{
				for(int i = 0; i < 25; i++)
				{
					[action modifyBoundsWithGestureVector:[comm getNextIncomingLine]];
				}
			}
			else if([userInput2 isEqualToString:@"n"] || [userInput2 isEqualToString:@"N"])
			{
				NSLog(@"the upperBound: %@ and lowerBound:%@ has been assigned to string: %@",action.upperBound, action.lowerBound, action.correspondingCharacter);
				NSLog(@"do you want to continue adding gestures? [y/n]");
                
				char word3[40];
				int nChars3 = scanf("%39s", word3);
				NSString *userInput3 = [[NSString alloc] initWithBytes:word3 length:nChars3 encoding:NSASCIIStringEncoding];
                
				if([userInput3 isEqualToString:@"y"] || [userInput3 isEqualToString:@"Y"])
				{
					[recognizer addActionDefinition:action];
					continueAddingGestures = YES;
				}
				else if([userInput3 isEqualToString:@"n"] || [userInput3 isEqualToString:@"N"])
				{
					[recognizer addActionDefinition:action];
				}
			}
		} while(continueAddingGestures);
        
		NSLog(@"now recognizing...");
		while(TRUE)
		{
			NSString *recognizedString = [recognizer isAction:[comm getNextIncomingLine]];
			if (!recognizedString)
			{}
			else
			{
				NSLog(@"%@", recognizedString);
			}
		}
        
        
        //        SDRecognizer *recognizer = [[SDRecognizer alloc]init];
        //
        //        NSMutableArray *testDefinitions = [[NSMutableArray alloc]init];
        //        for (int i = 0; i < 10; i++)
        //        {
        //            [testDefinitions addObject:[[NSNumber alloc]initWithInt:11]];
        //        }
        //
        //        [recognizer addGestureVector:[[NSArray alloc]initWithArray:testDefinitions copyItems:YES]
        //                                 for:@"sucess"];
        //
        //        NSMutableArray *aDefinitions = [[NSMutableArray alloc]initWithObjects:
        //                                        [[NSNumber alloc]initWithInt:912],
        //                                        [[NSNumber alloc]initWithInt:796],
        //                                        [[NSNumber alloc]initWithInt:897],
        //                                        [[NSNumber alloc]initWithInt:829],
        //                                        [[NSNumber alloc]initWithInt:914],
        //                                        [[NSNumber alloc]initWithInt:840],
        //                                        [[NSNumber alloc]initWithInt:872],
        //                                        [[NSNumber alloc]initWithInt:857],
        //                                        [[NSNumber alloc]initWithInt:1023],
        //                                        [[NSNumber alloc]initWithInt:826],nil];
        //        NSMutableArray *bDefinitions = [[NSMutableArray alloc]initWithObjects:
        //                                        [[NSNumber alloc]initWithInt:919],
        //                                        [[NSNumber alloc]initWithInt:844],
        //                                        [[NSNumber alloc]initWithInt:753],
        //                                        [[NSNumber alloc]initWithInt:741],
        //                                        [[NSNumber alloc]initWithInt:808],
        //                                        [[NSNumber alloc]initWithInt:780],
        //                                        [[NSNumber alloc]initWithInt:744],
        //                                        [[NSNumber alloc]initWithInt:782],
        //                                        [[NSNumber alloc]initWithInt:1023],
        //                                        [[NSNumber alloc]initWithInt:715],nil];
        //        NSMutableArray *cDefinitions = [[NSMutableArray alloc]initWithObjects:
        //                                        [[NSNumber alloc]initWithInt:901],
        //                                        [[NSNumber alloc]initWithInt:842],
        //                                        [[NSNumber alloc]initWithInt:858],
        //                                        [[NSNumber alloc]initWithInt:744],
        //                                        [[NSNumber alloc]initWithInt:889],
        //                                        [[NSNumber alloc]initWithInt:782],
        //                                        [[NSNumber alloc]initWithInt:856],
        //                                        [[NSNumber alloc]initWithInt:771],
        //                                        [[NSNumber alloc]initWithInt:1023],
        //                                        [[NSNumber alloc]initWithInt:742],nil];
        //        NSMutableArray *dDefinitions = [[NSMutableArray alloc]initWithObjects:
        //                                        [[NSNumber alloc]initWithInt:912],
        //                                        [[NSNumber alloc]initWithInt:844],
        //                                        [[NSNumber alloc]initWithInt:749],
        //                                        [[NSNumber alloc]initWithInt:738],
        //                                        [[NSNumber alloc]initWithInt:877],
        //                                        [[NSNumber alloc]initWithInt:811],
        //                                        [[NSNumber alloc]initWithInt:852],
        //                                        [[NSNumber alloc]initWithInt:795],
        //                                        [[NSNumber alloc]initWithInt:1023],
        //                                        [[NSNumber alloc]initWithInt:764],nil];
        //
        //        [comm.incomingStack.recognizer addSingleActionDefinition:[[NSArray alloc]initWithArray:aDefinitions copyItems:YES]  for:@"A"];
        //        [comm.incomingStack.recognizer addSingleActionDefinition:[[NSArray alloc]initWithArray:bDefinitions copyItems:YES]  for:@"B"];
        //        [comm.incomingStack.recognizer addSingleActionDefinition:[[NSArray alloc]initWithArray:cDefinitions copyItems:YES]  for:@"C"];
        //        [comm.incomingStack.recognizer addSingleActionDefinition:[[NSArray alloc]initWithArray:dDefinitions copyItems:YES]  for:@"D"];
        //
        //        NSLog(@"working with definition for %@ with upper %@ and lower %@",
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:0] correspondingString],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:0] upperBound],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:0] lowerBound]);
        //
        //        NSLog(@"working with definition for %@ with upper %@ and lower %@",
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:1] correspondingString],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:1] upperBound],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:1] lowerBound]);
        //
        //        NSLog(@"working with definition for %@ with upper %@ and lower %@",
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:2] correspondingString],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:2] upperBound],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:2] lowerBound]);
        //
        //        NSLog(@"working with definition for %@ with upper %@ and lower %@",
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:3] correspondingString],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:3] upperBound],
        //              [[comm.incomingStack.recognizer.mainActionDefinitionStack objectAtIndex:3] lowerBound]);
        //        
        //        NSString *gestureRecognized = [[NSString alloc] initWithString:[comm.incomingStack.recognizer isAction:comm.incomingStack.pendingGesture]];
        //
        //        
        //	    [comm autoTrySerialPortWithBaudRate:baud];
        //
        //        while (YES)
        //        {
        //            NSArray *nextLine = [comm getNextIncomingLine];
        //        }
        
	}
	return 0;
}