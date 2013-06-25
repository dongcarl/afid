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

- (void)incomingTextUpdateThread;//: (NSThread *) parentThread;
- (void)listAvailiableSerialPorts;
//- (void)openSerialPortAtBaudRate: (speed_t)baudRate;
- (NSString *) openSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate;
- (void) selectSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate;

@property struct termios gOriginalTTYAttrs;
@property int serialFileDescriptor;
@property SDIncomingStack *incomingStack;

@end