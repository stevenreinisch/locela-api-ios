//
// Created by steven reinisch on 23/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFDatetimeFormatter.h"


@implementation RFDatetimeFormatter

- (void)setStyle:(NSDateFormatterStyle)style forFormatter:(NSDateFormatter *)formatter
{
    [formatter setDateStyle:style];
    [formatter setTimeStyle:style];
}

@end