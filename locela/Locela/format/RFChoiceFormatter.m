//
//  RFChoiceFormatter.m
//  locela
//
//  Created by steffen on 25/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFChoiceFormatter.h"
#import "RFChoiceCondition.h"
#import "RFRegExpUtil.h"

#pragma mark - constants

NSString *const kRFChoiceConditionTestPattern = @"\\d(#|<)";

#pragma mark -

@implementation RFChoiceFormatter

- (NSRange)rangeOfIndexInPlaceholder:(NSString *)placeholder
{
    NSRange commaRange = [placeholder rangeOfString:@","];
    return NSMakeRange(1, commaRange.location);
}

- (NSRange)formatRangeFromPlaceholder:(NSString *)placeholder
{
    return [placeholder rangeOfString:@"choice,"];
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

#pragma mark - private

- (NSArray *)conditionsFromString:(NSString *)string
{
    NSMutableArray *conditions = [[NSMutableArray alloc] init];


    return [NSArray arrayWithArray:conditions];
}

- (RFChoiceCondition *)extractConditionFromString:(NSString *)string
                           stringWithoutCondition:(NSString **)withoutCondition
{
    RFChoiceCondition *condition = nil;

    NSRange pipeRange = [string rangeOfString:@"|"];

    if (NSNotFound != pipeRange.location)
    {
        NSRange conditionRange    = NSMakeRange(0, pipeRange.location);
        NSString *conditionString = [string substringWithRange:conditionRange];

        NSTextCheckingResult *result = nil;
        NSError               *error = nil;

        BOOL regExpOk = [RFRegExpUtil matchString:string
                             againstRegExpPattern:kRFChoiceConditionTestPattern
                                            match:&result
                                            error:&error];

        if (!regExpOk)//The regExp might be malformed.
        {
            return nil;
        }

        if (result)
        {
            NSString *test = [conditionString substringWithRange:NSMakeRange(0, result.range.length - 1)];
            char operator  = [[conditionString substringWithRange:NSMakeRange(result.range.length - 1, 1)]
                                            UTF8String][0];
            NSString *subPattern = [conditionString substringWithRange:NSMakeRange(result.range.length, conditionString.length - result.range.length)];

            condition = [[RFChoiceCondition alloc] initWithTest:test
                                                       operator:operator
                                                     subPattern:subPattern];

            *withoutCondition = [string substringWithRange:
                                     NSMakeRange(pipeRange.location + 1, string.length - pipeRange.location - 1)];
        }
    }

    return condition;
}

@end
