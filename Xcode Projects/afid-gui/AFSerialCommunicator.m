//
//  AFSerialCommunicator.m
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFSerialCommunicator.h"

@implementation AFSerialCommunicator

@synthesize  arduinoSerialFileDescriptor = _arduinoSerialFileDescriptor;
@synthesize gOriginalTTYAttrs;
@synthesize expectedGestureVectorDimensions;
@synthesize baudRate;
//@synthesize incomingStack = _incomingStack;

//lazy instantiations
-(int)arduinoSerialFileDescriptor
{
	if (!_arduinoSerialFileDescriptor)
	{
		_arduinoSerialFileDescriptor = -1;
	}
	return _arduinoSerialFileDescriptor;
}

-(BOOL)hasOpenedPort
{
	if (self.arduinoSerialFileDescriptor == -1)
	{
		return FALSE;
	}
	else
	{
		return TRUE;
	}
}

//initializers
- (AFSerialCommunicator *)initByOpeningSerialPort:(NSString *)serialPortFile
                                     withBaudRate:(speed_t)incomingBaudRate
{
	return [self initByOpeningSerialPort:serialPortFile atBaudRate:incomingBaudRate openPort:YES withExpectedDimensions:10];
}

- (AFSerialCommunicator *)initByOpeningSerialPort:(NSString *)incomingSerialPortFile
                                       atBaudRate:(speed_t)incomingBaudRate
		                                 openPort:(BOOL)openPort
				           withExpectedDimensions:(int)incomingExpectedDimensions
{
	if (self = [super init])
	{
		if (openPort)
		{
			[self openSerialPort:incomingSerialPortFile atBaudRate:incomingBaudRate];
		}
		else
		{
			[self closeOpenedSerialPort];
		}
		self.expectedGestureVectorDimensions = incomingExpectedDimensions;
	}
	return self;
}

- (id)init
{
    return [self initAndAutoOpenSerialPortWithBaudRate:2000000];
}

- (AFSerialCommunicator *)initAndAutoOpenSerialPortWithBaudRate:(speed_t)incomingBaudRate
{
	return [self initAndAutoOpenSerialPortWithBaudRate:incomingBaudRate expectedDimensions:10];
}

- (AFSerialCommunicator *)initAndAutoOpenSerialPortWithBaudRate:(speed_t)incomingBaudRate
                                             expectedDimensions:(int)incomingExpectedDimensions
{
	if (self = [super init])
	{
		[self autoTryThenOpenSerialPortAtBaudRate:incomingBaudRate];
		self.expectedGestureVectorDimensions = incomingExpectedDimensions;
	}
	return self;

}

//open and close ports
- (void)closeOpenedSerialPort
{
	if(self.hasOpenedPort)
	{
		close(self.arduinoSerialFileDescriptor);
		self.arduinoSerialFileDescriptor = -1;
	}
	else
	{
		NSLog(@"cannot close port because port never opened");
	}
	//checking...
	if (self.hasOpenedPort)
	{
		NSLog(@"error closing port with closeOpenedSerialPort");
	}
}

- (NSString *)openSerialPort:(NSString *)incomingSerialPortFile
{
	NSString *resultingErrorMessage = [self openSerialPort:incomingSerialPortFile atBaudRate:self.baudRate];
	return resultingErrorMessage;
}

- (NSString *)openSerialPort:(NSString *)incomingSerialPortFile
                  atBaudRate:(speed_t)incomingBaudRate
{
	NSMutableString *resultingErrorMessage = nil;

	if (self.hasOpenedPort)
	{
		resultingErrorMessage = [[NSMutableString alloc]initWithFormat:@"port already open! cannot open another port! terminating!"];
	}
	else
	{
		int success;
//
//		// close the port if it is already open
//		if (self.arduinoSerialFileDescriptor != -1)
//		{
//			close(self.arduinoSerialFileDescriptor);
//			self.arduinoSerialFileDescriptor = -1;
//
//			// wait for the reading thread to die
////		while(readThreadRunning);
//
//			// re-opening the same port REALLY fast will fail spectacularly... better to sleep a sec
//			sleep(0.5);
//		}

		// c-string path to serial-port file
		const char *bsdPath = [incomingSerialPortFile cStringUsingEncoding:NSUTF8StringEncoding];

		// Hold the original termios attributes we are setting
		struct termios options;

		// receive latency ( in microseconds )
		unsigned long mics = 3;

		// error message string

		// open the port
		//     O_NONBLOCK causes the port to open without any delay (we'll block with another call)
		self.arduinoSerialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );

		if (self.arduinoSerialFileDescriptor == -1) {
			// check if the port opened correctly
			resultingErrorMessage = [[NSMutableString alloc] initWithString:@"Error: couldn't open serial port"];
		} else {
			// TIOCEXCL causes blocking of non-root processes on this serial-port
			success = ioctl(self.arduinoSerialFileDescriptor, TIOCEXCL);
			if ( success == -1) {
				resultingErrorMessage = [[NSMutableString alloc] initWithString:@"Error: couldn't obtain lock on serial port"];
			} else {
				success = fcntl(self.arduinoSerialFileDescriptor, F_SETFL, 0);
				if ( success == -1) {
					// clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
					resultingErrorMessage = [[NSMutableString alloc] initWithString:@"Error: couldn't obtain lock on serial port"];
				} else {
					// Get the current options and save them so we can restore the default settings later.
					success = tcgetattr(self.arduinoSerialFileDescriptor, &gOriginalTTYAttrs);
					if ( success == -1) {
						resultingErrorMessage = [[NSMutableString alloc] initWithString:@"Error: couldn't get serial attributes"];
					} else {
						// copy the old termios settings into the current
						//   you want to do this so that you get all the control characters assigned
						options = gOriginalTTYAttrs;

						/*
						 cfmakeraw(&options) is equivilent to:
						 options->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
						 options->c_oflag &= ~OPOST;
						 options->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
						 options->c_cflag &= ~(CSIZE | PARENB);
						 options->c_cflag |= CS8;
						 */
						cfmakeraw(&options);

						// set tty attributes (raw-mode in this case)
						success = tcsetattr(self.arduinoSerialFileDescriptor, TCSANOW, &options);
						if ( success == -1) {
							resultingErrorMessage = [[NSMutableString alloc] initWithString:@"Error: coudln't set serial attributes"];
						} else {
							// Set baud rate (any arbitrary baud rate can be set this way)
							success = ioctl(self.arduinoSerialFileDescriptor, IOSSIOSPEED, &incomingBaudRate);
							if ( success == -1) {
								resultingErrorMessage = [[NSMutableString alloc] initWithString:@"Error: Baud Rate out of bounds"];
							} else {
								// Set the receive latency (a.k.a. don't wait to buffer data)
								success = ioctl(self.arduinoSerialFileDescriptor, IOSSDATALAT, &mics);
								if ( success == -1) {
									resultingErrorMessage = [[NSMutableString alloc] initWithString:@"Error: coudln't set serial latency"];
								}
							}
						}
					}
				}
			}
		}

		// make sure the port is closed if a problem happens
		if ((self.hasOpenedPort) && (resultingErrorMessage != nil))
		{
			NSLog(@"closing inside open");
			[self closeOpenedSerialPort];
		}

	}

	NSLog(@"open serial port finished with error: %@", resultingErrorMessage);

	return resultingErrorMessage;
}

- (NSString *)trySerialPort:(NSString *)serialPortFile
{
	NSString *resultingErrorMessage = [self trySerialPort:serialPortFile atBaudRate:self.baudRate];
	return resultingErrorMessage;
}

- (NSString *)trySerialPort:(NSString *)serialPortFile
                 atBaudRate:(speed_t)incomingBaudRate
{
	NSLog(@"trying serial port... %@", serialPortFile);
	NSString *errorMessageFromOpeningPort = [self openSerialPort:serialPortFile atBaudRate:incomingBaudRate];
	[self closeOpenedSerialPort];
	return errorMessageFromOpeningPort;
}

- (void)autoTryThenOpenSerialPort
{
	[self autoTryThenOpenSerialPortAtBaudRate:self.baudRate];
}

- (void)autoTryThenOpenSerialPortAtBaudRate:(speed_t)incomingBaudRate
{
	NSLog(@"auto opening serial port...");
	NSArray *availableSerialPortsExcludingBluetoothPorts = [AFSerialCommunicator availableArduinoSerialPorts];
	for(NSString *currentPort in availableSerialPortsExcludingBluetoothPorts)
	{
		NSString *currentErrorMessage = [self trySerialPort:currentPort atBaudRate:incomingBaudRate];
		if (!currentErrorMessage)
		{
			[self openSerialPort:currentPort atBaudRate:incomingBaudRate];
			break;
		}
		else
		{
			NSLog(@"serial port connection failed, error: %@", currentErrorMessage);
		}
	}
}


//listing ports
+ (NSArray *)availableSerialPorts
{
	NSMutableArray *result = [[NSMutableArray alloc]init];

	io_object_t serialPort;
	io_iterator_t serialPortIterator;

	// ask for all the serial ports
	IOServiceGetMatchingServices(
			kIOMasterPortDefault,
			IOServiceMatching(kIOSerialBSDServiceValue),
			&serialPortIterator);

	NSLog(@"all serial ports:");
	// loop through all the serial ports
	while ((serialPort = IOIteratorNext(serialPortIterator)))
	{
		NSString *serialPortOfInterest = [[NSString alloc]initWithString:(NSString *)CFBridgingRelease(IORegistryEntryCreateCFProperty(serialPort, CFSTR(kIOCalloutDeviceKey),kCFAllocatorDefault, 0))];
		// you want to do something useful here
		NSLog(@"    %@",serialPortOfInterest);
		[result addObject:serialPortOfInterest];
		IOObjectRelease(serialPort);
	}

	IOObjectRelease(serialPortIterator);

	return [[NSArray alloc] initWithArray:result copyItems:YES];
}

+ (NSArray *)availableArduinoSerialPorts
{
	NSMutableArray *allAvailableSerialPorts = [[NSMutableArray alloc] initWithArray:[self availableSerialPorts] copyItems:YES];
	NSMutableArray *itemsToBeRemoved = [[NSMutableArray alloc]init];

	for (NSString *currentPort in allAvailableSerialPorts)
	{
		if (![currentPort hasPrefix:@"/dev/cu.usbmodem"])
		{
			[itemsToBeRemoved addObject:currentPort];
		}
	}
	[allAvailableSerialPorts removeObjectsInArray:itemsToBeRemoved];

	return [[NSArray alloc] initWithArray:allAvailableSerialPorts copyItems:YES];
}

//getting gesture vectors
- (NSArray *)nextGestureVectorFromOpenedSerialPort
{
	NSMutableArray *seperatedComponents;

	do {
		const int BUFFER_SIZE = 100;
		char byte_buffer[BUFFER_SIZE]; // buffer for holding incoming data
		long numBytes = 0; // number of bytes read during read
		NSString *incomingText; // incoming text from the serial port
		char endlinechar = '\n';
		NSString *endline = [[NSString alloc] initWithFormat:@"%c", endlinechar];

		NSString *currentLine = [[NSString alloc]init];

		BOOL firstEndLineFound = NO;
		BOOL lineDone = NO;

		while (!lineDone)
		{
			numBytes = read(self.arduinoSerialFileDescriptor, byte_buffer, BUFFER_SIZE);

			if(numBytes > 0)
			{
				incomingText = [[NSString alloc]initWithBytes:byte_buffer length:numBytes encoding:NSASCIIStringEncoding];

				long endlineloc = [incomingText rangeOfString:endline].location;

				if (endlineloc != NSNotFound) //if it contains the endline...
				{
					if (firstEndLineFound)
					{
						NSString *stringBeforeEndLine = [incomingText substringToIndex:(endlineloc)];
						currentLine = [currentLine stringByAppendingString:stringBeforeEndLine];
						lineDone = YES;
					}
					else
					{
						NSString *stringAfterEndLine = [incomingText substringFromIndex:(endlineloc+[endline length])];
						currentLine = [currentLine stringByAppendingString:stringAfterEndLine];
						firstEndLineFound = YES;
					}
				}
				else //if it doesn't contain the endline...
				{
					if (firstEndLineFound)
					{
						currentLine = [currentLine stringByAppendingString:incomingText];
					}
					else
					{}
				}
			}
		}

		seperatedComponents = [[NSMutableArray alloc]initWithArray:[currentLine componentsSeparatedByString:@" "] copyItems:YES];
//        NSLog(@"got seperated components: %@",seperatedComponents);

	} while ([seperatedComponents count]!=expectedGestureVectorDimensions);

	return seperatedComponents;
}

- (NSArray *)nextGestureVector
{
	NSArray *result;
	if (self.hasOpenedPort)
	{
		result = [self nextGestureVectorFromOpenedSerialPort];
	}
	else
	{
		[self autoTryThenOpenSerialPort];
		result = [self nextGestureVectorFromOpenedSerialPort];
	}
//	[self closeOpenedSerialPort];
	return result;
}

- (NSArray *)nextGestureVectors:(int)numberOfGestureVectors
{
	NSMutableArray *resultingArrayOfGestureVectors = [[NSMutableArray alloc]init];
	for (int i = 0; i < numberOfGestureVectors; i++)
	{
		[resultingArrayOfGestureVectors addObject:[self nextGestureVector]];
	}
	return resultingArrayOfGestureVectors;
}

//generating action definitions
- (AFActionDefinition *)actionDefinitionFromNext:(int)lines
                                  linesForString:(NSString *)incomingString
			                      withBufferSize:(int)incomingBufferSize
{
	NSMutableArray *incomingArrayOfGestureVectors = [[NSMutableArray alloc]initWithArray:[self nextGestureVectors:lines]];
	AFActionDefinition *resultingActionDefinition = [[AFActionDefinition alloc] initWithGestureVector:[incomingArrayOfGestureVectors objectAtIndex:0]
	                                                                                        andBuffer:incomingBufferSize
			                                                                                forString:incomingString];
	for (int i = 1; i < lines; i++)
	{
		[resultingActionDefinition modifyBoundsWithGestureVector:[incomingArrayOfGestureVectors objectAtIndex:i]];
	}
	return resultingActionDefinition;
}

- (NSError *)writeToFile:(NSString *)incomingOutputFilePath
              atomically:(BOOL)incomingAtomicWriteDecision
		fromNextGestures:(NSUInteger)incomingNumGestureVectors
 withCorrespondingString:(NSString *)incomingCorrespondingString
{
	NSArray *arrayOfGestureVectors = [self nextGestureVectors:(int)incomingNumGestureVectors];
	NSMutableString *resultingFile = [[NSMutableString alloc]init];

	NSString *lineSeperator = [[NSString alloc] initWithFormat:@"%c", '\n'];
	NSString *elementsSeperator = [[NSString alloc] initWithFormat:@","];

	for (NSArray *currentGestureVector in arrayOfGestureVectors)
	{
		[resultingFile appendString:incomingCorrespondingString];
		[resultingFile appendString:elementsSeperator];

		for (NSString *currentGestureDimension in currentGestureVector)
		{
			[resultingFile appendString:currentGestureDimension];

			if (currentGestureDimension != currentGestureVector.lastObject)
			{
				[resultingFile appendString:elementsSeperator];
			}
			else
			{
				[resultingFile appendString:lineSeperator];
			}
		}
	}

	NSError *resultingErrorFromWrite;

	[resultingFile writeToFile:incomingOutputFilePath atomically:incomingAtomicWriteDecision
	                  encoding:NSASCIIStringEncoding error:&resultingErrorFromWrite];

	return resultingErrorFromWrite;
}

@end