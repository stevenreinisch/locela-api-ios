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

    NSString *valueString = [self evaluateConditions:format value:value];
    [mutable replaceCharactersInRange:range withString:valueString];

    return [NSString stringWithString:mutable];
}

#pragma mark - private

- (NSString *)evaluateConditions:(NSString *)conditionsString
                           value:(id)value
{
    __block NSString *valueString = nil;
    NSArray *conditions = [self conditionsFromString:conditionsString];

    [conditions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        RFChoiceCondition *condition = (RFChoiceCondition *)obj;
        BOOL evaluation              = [condition evaluate:value];
        if (evaluation)
        {
            *stop = YES;

            valueString = [condition.subPattern copy];
        }
    }];

    return valueString;
}

- (NSArray *)conditionsFromString:(NSString *)string
{
    NSMutableArray *conditions = [[NSMutableArray alloc] init];

    if (string && ![@"" isEqualToString:string])
    {
        NSString *conditionsToParse = [string copy];
        RFChoiceCondition *condition = nil;

        while (![@"" isEqualToString:conditionsToParse])
        {
            condition = [self extractConditionFromString:&conditionsToParse];

            if (condition)
            {
                [conditions addObject:condition];
            }
        }
    }

    return [NSArray arrayWithArray:conditions];
}

- (RFChoiceCondition *)extractConditionFromString:(NSString **)string
{
    RFChoiceCondition *condition = nil;
    NSUInteger conditionEndIndex = [*string length];

    NSRange pipeRange = [*string rangeOfString:@"|"];

    if (NSNotFound != pipeRange.location) {
        conditionEndIndex = pipeRange.location;
    }
    NSRange conditionRange    = NSMakeRange(0, conditionEndIndex);
    NSString *conditionString = [*string substringWithRange:conditionRange];

    NSTextCheckingResult *result = nil;
    NSError               *error = nil;

    BOOL regExpOk = [RFRegExpUtil matchString:conditionString
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
        if (conditionEndIndex < [*string length])
        {
            *string = [*string substringWithRange:
                                      NSMakeRange(conditionEndIndex + 1, [*string length] - conditionEndIndex - 1)];
        }
        else
        {
            *string = @""; //this means we are finished extracting conditions
        }
    }

    return condition;
}

@end
