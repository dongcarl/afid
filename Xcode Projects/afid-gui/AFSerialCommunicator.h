//
//  AFSerialCommunicator.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFActionDefinition.h"
#import <Foundation/Foundation.h>

// import IOKit headers
#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include <IOKit/serial/ioss.h>
#include <sys/ioctl.h>


@interface AFSerialCommunicator : NSObject

@property struct termios gOriginalTTYAttrs;
@property (nonatomic) int arduinoSerialFileDescriptor;
@property int expectedGestureVectorDimensions;
@property (nonatomic) speed_t baudRate;

//initializers
- (AFSerialCommunicator *)initByOpeningSerialPort:(NSString *)serialPortFile
                                     withBaudRate:(speed_t)incomingBaudRate;
- (AFSerialCommunicator *)initByOpeningSerialPort:(NSString *)incomingSerialPortFile
                                       atBaudRate:(speed_t)incomingBaudRate
		                                 openPort:(BOOL)openPort
				           withExpectedDimensions:(int)incomingExpectedDimensions;
- (AFSerialCommunicator *)initAndAutoOpenSerialPortWithBaudRate:(speed_t)incomingBaudRate;
- (AFSerialCommunicator *)initAndAutoOpenSerialPortWithBaudRate:(speed_t)incomingBaudRate
                                             expectedDimensions:(int)incomingExpectedDimensions;

//try serial ports
- (void)closeOpenedSerialPort;
- (NSString *)openSerialPort:(NSString *)incomingSerialPortFile;
- (NSString *)openSerialPort:(NSString *)incomingSerialPortFile
                  atBaudRate:(speed_t)incomingBaudRate;
- (NSString *)trySerialPort:(NSString *)serialPortFile;
- (NSString *)trySerialPort:(NSString *)serialPortFile
                 atBaudRate:(speed_t)incomingBaudRate;
- (void)autoTryThenOpenSerialPort;
- (void)autoTryThenOpenSerialPortAtBaudRate:(speed_t)incomingBaudRate;

//listing ports
+ (NSArray *)availableSerialPorts;
+ (NSArray *)availableArduinoSerialPorts;

//getting gesture vectors
- (NSArray *)nextGestureVectorFromOpenedSerialPort;
- (NSArray *)nextGestureVector;
- (NSArray *)nextGestureVectors:(int)numberOfGestureVectors;

//generating action definitions
- (AFActionDefinition *)actionDefinitionFromNext:(int)lines
                                  linesForString:(NSString *)incomingString
			                      withBufferSize:(int)incomingBufferSize;

//outputting to file
- (NSError *)writeToFile:(NSString *)incomingOutputFilePath
              atomically:(BOOL)incomingAtomicWriteDecision
		fromNextGestures:(NSUInteger)incomingNumGestureVectors
 withCorrespondingString:(NSString *)incomingCorrespondingString;


@end