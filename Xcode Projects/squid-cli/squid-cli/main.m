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
        
        // insert code here...
//        NSLog(@"Hello, World!");
        
        SDSerialCommunicator *comm = [[SDSerialCommunicator alloc]init];
        [comm listAvailiableSerialPorts];
        speed_t baud = B9600;
        [comm selectSerialPort:@"/dev/cu.usbmodemfa131" baud:baud];
        
    }
    return 0;
}