//
// Created by steven reinisch on 17/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFStringFormatter.h"
#import "RFMessageFormatter.h"

@implementation RFStringFormatter

- (BOOL)formatFirstValuePlaceholderInString:(NSString *)string
                                      match:(NSTextCheckingResult *)match
                                     values:(NSArray *)values
                                     result:(NSString **)result
                                      error:(NSError **)error
{
    NSAssert(string, @"Cannot format nil");
    NSAssert(match,  @"Cannot format without a match");
    NSAssert(values, @"Cannot format without values");

    NSString *placeholder = [string substringWithRange:match.range];
    NSInteger index       = [self indexFromPlaceholder:placeholder];

    if (0 <= index && index < [values count])
    {
        id value = values[index];
        *result = [self replaceValue:value
                            inString:string
                             inRange:match.range];

        return YES;
    }
    else {
        *error = [NSError errorWithDomain:kRFMessageFormatterErrorDomain
                                     code:RFMessageFormatterErrorCodeNoValueAtIndex
                                 userInfo:@{@"index" : @(index)}];

        return NO;
    }
}

#pragma mark - private

- (NSInteger)indexFromPlaceholder:(NSString *)placeholder
{
    if (placeholder && ![@"" isEqualToString:placeholder])
    {
        NSRange range         = NSMakeRange(1, placeholder.length - 1);
        NSString *parsedIndex = [placeholder substringWithRange:range];
        NSScanner *scanner    = [NSScanner scannerWithString:parsedIndex];
        int scannedIndex      = -1;
        BOOL isInt            = [scanner scanInt:&scannedIndex];

        if (isInt)
        {
            return scannedIndex;
        }
        else
        {
            return NSIntegerMin;
        }
    }
    else
    {
        return NSIntegerMin;
    }
}

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
{
    NSMutableString *mutable = [NSMutableString stringWithString:string];

    NSString *valueString = [NSString stringWithFormat:@"%@", value];
    [mutable replaceCharactersInRange:range withString:valueString];

    return [NSString stringWithString:mutable];
}

@end