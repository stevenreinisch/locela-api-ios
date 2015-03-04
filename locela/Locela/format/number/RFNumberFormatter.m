//
// Created by steven reinisch on 17/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFNumberFormatter.h"
#import "RFMessageFormatter.h"


@implementation RFNumberFormatter

#pragma mark - private

- (NSRange)rangeOfIndexInPlaceholder:(NSString *)placeholder
{
    NSRange commaRange = [placeholder rangeOfString:@","];
    return NSMakeRange(1, commaRange.location);
}

- (NSRange)formatRangeFromPlaceholder:(NSString *)placeholder
{
    return [placeholder rangeOfString:@"number,"];
}

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                    format:(NSString *)format
{
    NSMutableString *mutable = [NSMutableString stringWithString:string];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

    [formatter setPositiveFormat:format];
    
    NSString *valueString = [formatter stringFromNumber:value];
    [mutable replaceCharactersInRange:range withString:valueString];
    
    return [NSString stringWithString:mutable];
}

@end