//
//  WTGMatrix.h
//  WrappingTrial
//
//  Created by Carl Dong on 7/7/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GClasses/GMatrix.h>

@interface WTGMatrix : NSObject

@property (nonatomic, readwrite, assign) GClasses::GMatrix *cpp;

- (WTGMatrix *)initWithARFFFile:(NSString *)incomingARFFFilePath;


@end
