//
// Created by steven reinisch on 20/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFValueFormatter.h"


@interface RFDateFormatter : RFValueFormatter

- (instancetype)initWithLocale:(NSLocale *)locale NS_DESIGNATED_INITIALIZER;

@end