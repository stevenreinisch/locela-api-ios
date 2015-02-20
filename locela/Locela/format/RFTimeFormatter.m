//
// Created by steven reinisch on 20/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFTimeFormatter.h"


@implementation RFTimeFormatter

- (void)setStyle:(NSDateFormatterStyle)style forFormatter:(NSDateFormatter *)formatter
{
    [formatter setTimeStyle:style];
}

@end