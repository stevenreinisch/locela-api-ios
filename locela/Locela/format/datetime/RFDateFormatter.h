//
// Created by steven reinisch on 20/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFBaseFormatter.h"


@interface RFDateFormatter : RFBaseFormatter

#pragma mark - protected

- (void)setStyle:(NSDateFormatterStyle)style forFormatter:(NSDateFormatter *)formatter;

@end