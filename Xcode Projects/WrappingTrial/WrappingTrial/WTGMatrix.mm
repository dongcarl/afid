//
//  WTGMatrix.m
//  WrappingTrial
//
//  Created by Carl Dong on 7/7/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "WTGMatrix.h"

@implementation WTGMatrix

@synthesize cpp = _cpp;

using namespace GClasses;
using namespace std;

- (WTGMatrix *)initWithARFFFile:(NSString *)incomingARFFFilePath
{
	if (self = [super init])
	{
		self.cpp = GClasses::GMatrix::loadArff([[incomingARFFFilePath stringByExpandingTildeInPath] UTF8String]);
	}
	return self;
}

- (NSString *)description
{
	std::ostringstream stream;  //initialize an output stream...
	self.cpp->print(stream);    //dump the data there
	NSString *description = [[NSString alloc] initWithFormat:@"%s", stream.str().c_str()];  //set description!
	return description;
}


@end
