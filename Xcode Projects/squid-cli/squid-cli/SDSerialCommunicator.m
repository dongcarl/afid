//
//  SDSerialCommunicator.m
//  squid-cli
//
//  Created by Carl Dong on 6/22/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDSerialCommunicator.h"

@implementation SDSerialCommunicator

@synthesize serialFileDescriptor;
@synthesize gOriginalTTYAttrs;
@synthesize incomingStack = _incomingStack;

//- (SDSerialCommunicator *)initWithBaudRate: (speed_t)baud
//{
//    SDSerialCommunicator *result = [self init];
//    [result openSerialPortAtBaudRate:baud];
//    return result;
//}

- (NSString *) selectSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate
{
    NSString *error = [self openSerialPort: serialPortFile baud:baudRate];
	
	if(error!=nil)
    {
        NSLog(@"%@", error);
        return error;
	}
    else
    {
		[self incomingTextUpdateThread];
        return nil;
	}
}

- (void)autoSelectSerialPortWithBaud: (speed_t)baudRate
{
    NSArray *serialPortArray = [self availiableSerialPorts];
    for (NSString *port in serialPortArray)
    {
        NSLog(@"trying to connect to serial port: %@...", port);
        if ([port hasPrefix:@"/dev/cu.Bluetooth"])
        {
            NSLog(@"this serial port is a bluetooth port, skipping...");
        }
        
        else
        {
            NSString *errorMessage = [self selectSerialPort:port baud:baudRate];
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

- (void)incomingTextUpdateThread//: (NSThread *) parentThread
{
    const int BUFFER_SIZE = 100;
	char byte_buffer[BUFFER_SIZE]; // buffer for holding incoming data
	long numBytes = 0; // number of bytes read during read
	NSString *text; // incoming text from the serial port
    char endlinechar = '\n';
    NSString *endline = [[NSString alloc] initWithFormat:@"%c", endlinechar];
    
    NSString *currentLine;
    self.incomingStack = [[SDIncomingStack alloc]init];
    
    while(TRUE)
    {
		// read() blocks until some data is available or the port is closed
		numBytes = read(serialFileDescriptor, byte_buffer, BUFFER_SIZE); // read up to the size of the buffer
		if(numBytes>0)
        {
			// create an NSString from the incoming bytes (the bytes aren't null terminated)
			text = [NSString stringWithCString:byte_buffer length:numBytes];
			
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
            [self.incomingStack push:[currentLine substringToIndex:currentLine.length-2]];
            currentLine = [[NSString alloc]init];
            currentLine = [currentLine stringByAppendingString:[text substringFromIndex:endlineloc+[endline length]]];
        }
        else
        {
            currentLine = [currentLine stringByAppendingString:text];
        }
    }
}

- (NSArray *)availiableSerialPorts
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


- (NSString *) openSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate {
	int success;
	
	// close the port if it is already open
	if (serialFileDescriptor != -1) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
		
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
	serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );
	
	if (serialFileDescriptor == -1) {
		// check if the port opened correctly
		errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: couldn't open serial port"];
	} else {
		// TIOCEXCL causes blocking of non-root processes on this serial-port
		success = ioctl(serialFileDescriptor, TIOCEXCL);
		if ( success == -1) {
			errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: couldn't obtain lock on serial port"];
		} else {
			success = fcntl(serialFileDescriptor, F_SETFL, 0);
			if ( success == -1) {
				// clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
				errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: couldn't obtain lock on serial port"];
			} else {
				// Get the current options and save them so we can restore the default settings later.
				success = tcgetattr(serialFileDescriptor, &gOriginalTTYAttrs);
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
					success = tcsetattr(serialFileDescriptor, TCSANOW, &options);
					if ( success == -1) {
						errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: coudln't set serial attributes"];
					} else {
						// Set baud rate (any arbitrary baud rate can be set this way)
						success = ioctl(serialFileDescriptor, IOSSIOSPEED, &baudRate);
						if ( success == -1) {
							errorMessage = [[NSMutableString alloc] initWithFormat:@"Error: Baud Rate out of bounds"];
						} else {
							// Set the receive latency (a.k.a. don't wait to buffer data)
							success = ioctl(serialFileDescriptor, IOSSDATALAT, &mics);
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
	if ((serialFileDescriptor != -1) && (errorMessage != nil)) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
	}
	
	return errorMessage;
}


@end
