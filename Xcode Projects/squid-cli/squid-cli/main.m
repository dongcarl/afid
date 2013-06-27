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
        
        NSMutableArray *testDefinitions = [[NSMutableArray alloc]init];

        for (int i = 0; i < 10; i++)
        {
            [testDefinitions addObject:[[NSNumber alloc]initWithInt:11]];
        }
        
        [comm.incomingStack.recognizer addActionDefinition:[[NSArray alloc]initWithArray:testDefinitions copyItems:YES]  for:@"success"];
        
        NSMutableArray *aDefinitions = [[NSMutableArray alloc]initWithObjects:
                                        [[NSNumber alloc]initWithInt:912],
                                        [[NSNumber alloc]initWithInt:796],
                                        [[NSNumber alloc]initWithInt:897],
                                        [[NSNumber alloc]initWithInt:829],
                                        [[NSNumber alloc]initWithInt:914],
                                        [[NSNumber alloc]initWithInt:840],
                                        [[NSNumber alloc]initWithInt:872],
                                        [[NSNumber alloc]initWithInt:857],
                                        [[NSNumber alloc]initWithInt:1023],
                                        [[NSNumber alloc]initWithInt:826],nil];
        NSMutableArray *bDefinitions = [[NSMutableArray alloc]initWithObjects:
                                        [[NSNumber alloc]initWithInt:919],
                                        [[NSNumber alloc]initWithInt:844],
                                        [[NSNumber alloc]initWithInt:753],
                                        [[NSNumber alloc]initWithInt:741],
                                        [[NSNumber alloc]initWithInt:808],
                                        [[NSNumber alloc]initWithInt:780],
                                        [[NSNumber alloc]initWithInt:744],
                                        [[NSNumber alloc]initWithInt:782],
                                        [[NSNumber alloc]initWithInt:1023],
                                        [[NSNumber alloc]initWithInt:715],nil];
        NSMutableArray *cDefinitions = [[NSMutableArray alloc]initWithObjects:
                                        [[NSNumber alloc]initWithInt:901],
                                        [[NSNumber alloc]initWithInt:842],
                                        [[NSNumber alloc]initWithInt:858],
                                        [[NSNumber alloc]initWithInt:744],
                                        [[NSNumber alloc]initWithInt:889],
                                        [[NSNumber alloc]initWithInt:782],
                                        [[NSNumber alloc]initWithInt:856],
                                        [[NSNumber alloc]initWithInt:771],
                                        [[NSNumber alloc]initWithInt:1023],
                                        [[NSNumber alloc]initWithInt:742],nil];
        NSMutableArray *dDefinitions = [[NSMutableArray alloc]initWithObjects:
                                        [[NSNumber alloc]initWithInt:912],
                                        [[NSNumber alloc]initWithInt:844],
                                        [[NSNumber alloc]initWithInt:749],
                                        [[NSNumber alloc]initWithInt:738],
                                        [[NSNumber alloc]initWithInt:877],
                                        [[NSNumber alloc]initWithInt:811],
                                        [[NSNumber alloc]initWithInt:852],
                                        [[NSNumber alloc]initWithInt:795],
                                        [[NSNumber alloc]initWithInt:1023],
                                        [[NSNumber alloc]initWithInt:764],nil];
        
        [comm.incomingStack.recognizer addActionDefinition:[[NSArray alloc]initWithArray:aDefinitions copyItems:YES]  for:@"A"];
        [comm.incomingStack.recognizer addActionDefinition:[[NSArray alloc]initWithArray:bDefinitions copyItems:YES]  for:@"B"];
        [comm.incomingStack.recognizer addActionDefinition:[[NSArray alloc]initWithArray:cDefinitions copyItems:YES]  for:@"C"];
        [comm.incomingStack.recognizer addActionDefinition:[[NSArray alloc]initWithArray:dDefinitions copyItems:YES]  for:@"D"];
        
        NSLog(@"working with definition for %@ with upper %@ and lower %@", [[comm.incomingStack.recognizer.definitions objectAtIndex:1] correspondingCharacter],
                                                                            [[comm.incomingStack.recognizer.definitions objectAtIndex:1] upperBound],
                                                                            [[comm.incomingStack.recognizer.definitions objectAtIndex:1] lowerBound]);
        
        NSLog(@"working with definition for %@ with upper %@ and lower %@", [[comm.incomingStack.recognizer.definitions objectAtIndex:2] correspondingCharacter],
              [[comm.incomingStack.recognizer.definitions objectAtIndex:2] upperBound],
              [[comm.incomingStack.recognizer.definitions objectAtIndex:2] lowerBound]);
        
        NSLog(@"working with definition for %@ with upper %@ and lower %@", [[comm.incomingStack.recognizer.definitions objectAtIndex:3] correspondingCharacter],
              [[comm.incomingStack.recognizer.definitions objectAtIndex:3] upperBound],
              [[comm.incomingStack.recognizer.definitions objectAtIndex:3] lowerBound]);
        
        NSLog(@"working with definition for %@ with upper %@ and lower %@", [[comm.incomingStack.recognizer.definitions objectAtIndex:4] correspondingCharacter],
              [[comm.incomingStack.recognizer.definitions objectAtIndex:4] upperBound],
              [[comm.incomingStack.recognizer.definitions objectAtIndex:4] lowerBound]);
        
        
        [comm autoSelectSerialPortWithBaud:baud];
    }
    return 0;
}