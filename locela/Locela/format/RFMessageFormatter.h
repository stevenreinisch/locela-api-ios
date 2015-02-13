//
// Created by steven reinisch on 13/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RFMessageFormatter : NSObject

- (instancetype)initWithLocale:(NSLocale *)locale NS_DESIGNATED_INITIALIZER;

- (NSString *)formatPattern:(NSString *)pattern
                     values:(id)firstValue, ... NS_REQUIRES_NIL_TERMINATION;

@end