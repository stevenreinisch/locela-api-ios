//
// Created by steven reinisch on 17/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFValueFormatter.h"

/*
 * This class formats placeholders with this pattern: {<index>,number,<numberFormat>}
 * where index is an NSUInteger and numberFormat a number format.
 *
 * Examples: {0,number,0E00}, {1,number,%0.00}
 */
@interface RFNumberFormatter : RFValueFormatter
@end