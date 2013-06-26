//
//  main.m
//  squid-cli
//
//  Created by Carl Dong on 6/22/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDSerialCommunicator.h"
#import "SDDefinitionMutableArray.h"

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {     
//        speed_t baud = B9600;
//        [[[SDSerialCommunicator alloc]init] autoSelectSerialPortWithBaud:baud];
//        
//        NSLog(@"program terminating...");
        NSArray *testDefinitions = [[NSArray alloc]initWithObjects: [[NSNumber alloc]initWithInt:123], [[NSNumber alloc]initWithInt:123], nil];        
        NSMutableArray *ZDefinition = [[NSMutableArray alloc] init];
        NSMutableArray *ZTest = [[NSMutableArray alloc]init];
        NSMutableArray *ZTest2 = [[NSMutableArray alloc]init];

        
        for (int i = 0; i < 10; i++)
        {
            [ZDefinition addObject: [[NSNumber alloc]initWithInt:i]];
            [ZTest addObject:[[NSNumber alloc]initWithInt:i+10]];
            [ZTest2 addObject:[[NSNumber alloc]initWithInt:i-10]];

        }
        
        SDDefinitionMutableArray *currentDefinitions = [[SDDefinitionMutableArray alloc]init];
        [currentDefinitions addActionDefinition:testDefinitions for:@"A"];
        [currentDefinitions addActionDefinition:ZDefinition for:@"Z"];
        
        NSLog(@"%@", [currentDefinitions isAction:testDefinitions]);
        NSLog(@"%@", [currentDefinitions isAction:ZTest]);
        NSLog(@"%@", [currentDefinitions isAction:ZTest2]);

    }
    return 0;
}