//
//  SDSerialCommunicator.h
//  squid-cli
//
//  Created by Carl Dong on 6/22/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Cocoa/Cocoa.h>
#import "SDIncomingStack.h"

// import IOKit headers
#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include <IOKit/serial/ioss.h>
#include <sys/ioctl.h>

@interface SDSerialCommunicator : NSObject

//initializers
- (SDSerialCommunicator *)initWithSerialPort:(NSString *)serialPortFile
								withBaudRate:(speed_t)baudRate;
- (SDSerialCommunicator *)initAndAutoTryPortsWithBaudRate:(speed_t)baudRate;


- (void)keepGettingIncomingLines;//: (NSThread *) parentThread;
- (NSArray *)availableSerialPorts;
//- (void)openSerialPortAtBaudRate: (speed_t)baudRate;
- (NSString *)trySerialPort:(NSString *)serialPortFile
               withBaudRate: (speed_t)baudRate;

- (void)autoTrySerialPortWithBaudRate: (speed_t)baudRate;
- (NSArray *)getNextIncomingLine;

- (SDActionDefinition *)actionDefinitionFromNext:(NSUInteger *)incomingNumberOfLines
                                  linesForString:(NSString *)incomingString;


@property struct termios gOriginalTTYAttrs;
@property (nonatomic) int serialFileDescriptor;
@property (nonatomic) SDIncomingStack *incomingStack;

@end