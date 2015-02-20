//
// Created by steven reinisch on 17/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFNumberFormatter.h"
#import "RFMessageFormatter.h"


@implementation RFNumberFormatter

- (BOOL)formatFirstValuePlaceholderInString:(NSString *)string
                                      match:(NSTextCheckingResult *)match
                                     values:(NSArray *)values
                                     result:(NSString **)result
                                      error:(NSError **)error
{
    NSAssert(string, @"Cannot format nil");
    NSAssert(match,  @"Cannot format without a match");
    NSAssert(values, @"Cannot format without values");

    NSString *placeholder  = [string substringWithRange:match.range];
    NSInteger index        = [self indexFromPlaceholder:placeholder];
    NSString *numberFormat = [self numberFormatFromPlaceholder:placeholder];

    if (0 <= index && index < [values count])
    {
        id value = values[index];
        *result = [self replaceValue:value
                            inString:string
                             inRange:match.range
                        numberFormat:numberFormat];

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
        NSRange commaRange    = [placeholder rangeOfString:@","];
        NSRange range         = NSMakeRange(1, commaRange.location);
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

- (NSString *)numberFormatFromPlaceholder:(NSString *)placeholder
{
    NSRange numberRange          = [placeholder rangeOfString:@"number,"];
    NSUInteger formatRangeStart  = numberRange.location + numberRange.length;
    NSUInteger formatRangeLength = placeholder.length - formatRangeStart;
    NSRange formatRange          = NSMakeRange(formatRangeStart, formatRangeLength - 1);
    NSString *format             = [placeholder substringWithRange:formatRange];

    return [format stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
              numberFormat:(NSString *)numberFormat
{
    NSMutableString *mutable = [NSMutableString stringWithString:string];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:numberFormat];
    
    NSString *valueString = [formatter stringFromNumber:value];
    [mutable replaceCharactersInRange:range withString:valueString];
    
    return [NSString stringWithString:mutable];
}

@end