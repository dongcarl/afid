//
//  SDSerialCommunicator.m
//  squid-cli
//
//  Created by Carl Dong on 6/22/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDSerialCommunicator.h"

@implementation SDSerialCommunicator

@synthesize serialFileDescriptor = _serialFileDescriptor;
@synthesize gOriginalTTYAttrs;
@synthesize incomingStack = _incomingStack;

//- (SDSerialCommunicator *)initWithBaudRate: (speed_t)baud
//{
//    SDSerialCommunicator *result = [self init];
//    [result openSerialPortAtBaudRate:baud];
//    return result;
//}


- (SDIncomingStack *)incomingStack
{
    if(!_incomingStack)
    {
        _incomingStack = [[SDIncomingStack alloc]init];
    }
    return _incomingStack;
}

- (int)serialFileDescriptor
{
    if(!_serialFileDescriptor)
    {
        _serialFileDescriptor = 0;
    }
    return _serialFileDescriptor;
}

- (void)autoTrySerialPortWithBaudRate: (speed_t)baudRate
{
    NSArray *serialPortArray = [self availableSerialPorts];
    for (NSString *port in serialPortArray)
    {
        NSLog(@"trying to connect to serial port: %@...", port);
        if ([port hasPrefix:@"/dev/cu.Bluetooth"])
        {
            NSLog(@"this serial port is a bluetooth port, skipping...");
        }
        
        else
        {
            NSString *errorMessage = [self trySerialPort:port withBaudRate:baudRate];

            if (errorMessage!=nil)
            {
                NSLog(@"serial port connection failed, error: %@", errorMessage);
            }
            else
            {
                NSLog(@"serial connection established, recieving data if availiable");
                break;
            }
        }
        
        if([port isEqualTo:[serialPortArray lastObject]])
        {
            NSLog(@"no more serial ports to try");
        }
        else
        {
            NSLog(@"trying next serial port...");
        }
    }
}


- (NSArray *)getNextIncomingLine
{
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
        numBytes = read(self.serialFileDescriptor, byte_buffer, BUFFER_SIZE);
        
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
    
    NSArray *seperatedComponents = [currentLine componentsSeparatedByString:@" "];
    
    return seperatedComponents;
}

- (SDActionDefinition *)actionDefinitionFromNext:(NSUInteger *)lines
                                  linesForString:(NSString *)incomingString
{
	SDIncomingStack *gestureValueStack = [[SDIncomingStack alloc]init];
	for(int i = 0; i < lines; i++)
	{
		[gestureValueStack push:[self getNextIncomingLine]];
	}
	SDActionDefinition *result = [[SDActionDefinition alloc] initWithGestureVector:[gestureValueStack pop] forString:incomingString];
	for(int i = 0; i < lines-1; i++)
	{
		[result modifyBoundsWithGestureVector:[gestureValueStack pop]];
	}

	return result;
}


- (SDSerialCommunicator *)initWithSerialPort:(NSString *)serialPortFile
                                withBaudRate:(speed_t)baudRate
{
	if(self = [super init])
	{
		[self trySerialPort:serialPortFile withBaudRate:baudRate];
	}

	return self;
}

- (SDSerialCommunicator *)initAndAutoTryPortsWithBaudRate:(speed_t)baudRate
{
	if (self = [super init])
	{
		[self autoTrySerialPortWithBaudRate:baudRate];
	}
	return self;
}

- (void)keepGettingIncomingLines//: (NSThread *) parentThread
{
    const int BUFFER_SIZE = 100;
	char byte_buffer[BUFFER_SIZE]; // buffer for holding incoming data
	long numBytes = 0; // number of bytes read during read
	NSString *text; // incoming text from the serial port
    char endlinechar = '\n';
    NSString *endline = [[NSString alloc] initWithFormat:@"%c", endlinechar];
    
    NSString *currentLine;
    
    //    int i = 0;
    //    sleep(10);
    
    while(TRUE)
    {
        
		// read() blocks until some data is available or the port is closed
		numBytes = read(self.serialFileDescriptor, byte_buffer, BUFFER_SIZE); // read up to the size of the buffer
        
        
        
		if(numBytes>0)
        {
            
            //			// create an NSString from the incoming bytes (the bytes aren't null terminated)
            //			text = [NSString stringWithCString:byte_buffer encoding:NSASCIIStringEncoding];
            
            text = [[NSString alloc]initWithBytes:byte_buffer length:numBytes encoding:NSASCIIStringEncoding];
            //            NSLog(@"%@", text);
            
            
            //            NSLog(@"%ld: %@", numBytes, text);
            //            if ([text characterAtIndex:([text length]-1)] == endlinechar || )
            //            {
            //                <#statements#>
            //            }
            //            NSMutableArray *arrayOfLine = [[NSMutableArray alloc]initWithArray:[text componentsSeparatedByString:endline copyItems:YES]];
            //            NSLog(@"%@", text);
			// this text can't be directly sent to the text area from this thread
			//  BUT, we can call a selctor on the main thread.
		}
        else
        {
			break; // Stop the thread if there is an error
		}
        
        long endlineloc = [text rangeOfString:endline].location;
        
        if (endlineloc != NSNotFound) //if it contains the endline...
        {
            currentLine = [currentLine stringByAppendingString:[text substringToIndex:endlineloc]];
            //            NSLog(@"%@", currentLine);
            [self.incomingStack push:[currentLine substringToIndex:currentLine.length]];
            currentLine = [[NSString alloc]init];
            currentLine = [currentLine stringByAppendingString:[text substringFromIndex:endlineloc+[endline length]]];
        }
        else
        {
            currentLine = [currentLine stringByAppendingString:text];
        }
    }
}

- (NSArray *)availableSerialPorts
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


- (NSString *)trySerialPort:(NSString *)serialPortFile
               withBaudRate: (speed_t)baudRate
{
	int success;
	
	// close the port if it is already open
	if (self.serialFileDescriptor != -1)
    {
		close(self.serialFileDescriptor);
		self.serialFileDescriptor = -1;
		
		// wait for the reading thread to die
		
		// re-opening the same port REALLY fast will fail spectacularly... better to sleep a sec
		sleep(0.5);
	}
	
	// c-string path to serial-port file
	const char *bsdPath = [serialPortFile cStringUsingEncoding:NSUTF8StringEncoding];
	
	// Hold the original termios attributes we are setting
	struct termios options;
	
	// receive latency ( in microseconds )
	unsigned long mics = 3;
	
	// error message string
	NSMutableString *errorMessage = nil;
	
	// open the port
	//     O_NONBLOCK causes the port to open without any delay (we'll block with another call)
	self.serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );
	
	if (self.serialFileDescriptor == -1) {
		// check if the port opened correctly
		errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: couldn't open serial port"];
	} else {
		// TIOCEXCL causes blocking of non-root processes on this serial-port
		success = ioctl(self.serialFileDescriptor, TIOCEXCL);
		if ( success == -1) {
			errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: couldn't obtain lock on serial port"];
		} else {
			success = fcntl(self.serialFileDescriptor, F_SETFL, 0);
			if ( success == -1) {
				// clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
				errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: couldn't obtain lock on serial port"];
			} else {
				// Get the current options and save them so we can restore the default settings later.
				success = tcgetattr(self.serialFileDescriptor, &gOriginalTTYAttrs);
				if ( success == -1) {
					errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: couldn't get serial attributes"];
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
					success = tcsetattr(self.serialFileDescriptor, TCSANOW, &options);
					if ( success == -1) {
						errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: coudln't set serial attributes"];
					} else {
						// Set baud rate (any arbitrary baud rate can be set this way)
						success = ioctl(self.serialFileDescriptor, IOSSIOSPEED, &baudRate);
						if ( success == -1) {
							errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: Baud Rate out of bounds"];
						} else {
							// Set the receive latency (a.k.a. don't wait to buffer data)
							success = ioctl(self.serialFileDescriptor, IOSSDATALAT, &mics);
							if ( success == -1) {
								errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: coudln't set serial latency"];
							}
						}
					}
				}
			}
		}
	}
	
	// make sure the port is closed if a problem happens
//	if ((self.arduinoSerialFileDescriptor != -1) && (errorMessage != nil)) {
		close(self.serialFileDescriptor);
		self.serialFileDescriptor = -1;
//	}
    
	return errorMessage;
}


@end
