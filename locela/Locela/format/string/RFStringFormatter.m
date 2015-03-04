//
// Created by steven reinisch on 17/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFStringFormatter.h"
#import "RFMessageFormatter.h"

@implementation RFStringFormatter

#pragma mark - private

- (NSRange)rangeOfIndexInPlaceholder:(NSString *)placeholder
{
    return NSMakeRange(1, placeholder.length - 1);
}

/*
 * This formatter handles no format.
 * Returns "empty" range
 */
- (NSRange)formatRangeFromPlaceholder:(NSString *)placeholder
{
    return NSMakeRange(NSNotFound, 0);
}

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                    format:(NSString *)format
{
    NSMutableString *mutable = [NSMutableString stringWithString:string];

    NSString *valueString = [NSString stringWithFormat:@"%@", value];
    [mutable replaceCharactersInRange:range withString:valueString];

    return [NSString stringWithString:mutable];
}

@end