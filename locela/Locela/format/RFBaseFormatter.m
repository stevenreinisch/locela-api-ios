//
// Created by steven reinisch on 17/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFBaseFormatter.h"
#import "RFMessageFormatter.h"
#import "RFMacros.h"

@implementation RFBaseFormatter

- (instancetype)initWithLocale:(NSLocale *)locale
{
    self = [super init];

    if (self)
    {
        if (!locale)
        {
            _locale = [NSLocale currentLocale];
        }
        else
        {
            _locale = locale;
        }
    }
    return self;
}

- (BOOL)replaceFirstPlaceholderInPattern:(NSString *)pattern
                                   match:(NSTextCheckingResult *)match
                                  values:(NSArray *)values
                                  result:(NSString **)result
                                   error:(NSError **)error
{
    NSAssert(pattern, @"Cannot format nil");
    NSAssert(match,  @"Cannot format without a match");
    NSAssert(values, @"Cannot format without values");

    NSString *placeholder = [pattern substringWithRange:match.range];
    NSInteger index       = [self indexFromPlaceholder:placeholder];
    NSString *format      = [self formatFromPlaceholder:placeholder];

    if (0 <= index && index < [values count])
    {
        id value = values[index];
        *result = [self replaceValue:value
                            inString:pattern
                             inRange:match.range
                              format:format];

        return YES;
    }
    else {
        *error = [NSError errorWithDomain:kRFMessageFormatterErrorDomain
                                     code:RFMessageFormatterErrorCodeNoValueAtIndex
                                 userInfo:@{@"index" : @(index)}];

        return NO;
    }
}

- (NSInteger)indexFromPlaceholder:(NSString *)placeholder
{
    if (placeholder && ![@"" isEqualToString:placeholder])
    {
        NSRange range         = [self rangeOfIndexInPlaceholder:placeholder];
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

- (NSRange)rangeOfIndexInPlaceholder:(NSString *)placeholder ABSTRACT_METHOD

- (NSRange)formatRangeFromPlaceholder:(NSString *)placeholder ABSTRACT_METHOD

- (NSString *)formatFromPlaceholder:(NSString *)placeholder
{
    NSString *format = nil;

    NSRange numberRange = [self formatRangeFromPlaceholder:placeholder];

    if (NSNotFound != numberRange.location)
    {
        NSUInteger formatRangeStart = numberRange.location + numberRange.length;
        NSUInteger formatRangeLength = placeholder.length - formatRangeStart;
        NSRange formatRange = NSMakeRange(formatRangeStart, formatRangeLength - 1);
        format = [[placeholder substringWithRange:formatRange]
                stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }

    return format;
}

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                    format:(NSString *)format ABSTRACT_METHOD

@end