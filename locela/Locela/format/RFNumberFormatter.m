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
    return 0;
}

- (NSString *)numberFormatFromPlaceholder:(NSString *)placeholder
{
    return nil;
}

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
              numberFormat:(NSString *)numberFormat
{
    return nil;
}

@end