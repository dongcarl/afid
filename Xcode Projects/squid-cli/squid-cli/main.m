//
//  main.m
//  squid-cli
//
//  Created by Carl Dong on 6/22/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDSerialCommunicator.h"

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {     
        speed_t baud = B9600;
        [[[SDSerialCommunicator alloc]init] autoSelectSerialPortWithBaud:baud];
        
        NSLog(@"program terminating...");
    }
    return 0;
}