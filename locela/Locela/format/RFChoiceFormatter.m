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

    NSString *withoutConditions  = [string copy];
    RFChoiceCondition *condition = nil;

    //while (![@"" isEqualToString:withoutConditions])
    {
        //condition = [self extractConditionFromString:withoutConditions];// stringWithoutCondition:<#(NSString **)withoutCondition#>]
    }

    return [NSArray arrayWithArray:conditions];
}

- (RFChoiceCondition *)extractConditionFromString:(NSString *)string
                           stringWithoutCondition:(NSString **)withoutCondition
{
    RFChoiceCondition *condition = nil;
    NSUInteger conditionEndIndex = string.length;

    NSRange pipeRange = [string rangeOfString:@"|"];

    if (NSNotFound != pipeRange.location) {
        conditionEndIndex = pipeRange.location;
    }
        NSRange conditionRange    = NSMakeRange(0, conditionEndIndex);
        NSString *conditionString = [string substringWithRange:conditionRange];

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
            if (conditionEndIndex < string.length)
            {
                *withoutCondition = [string substringWithRange:
                                          NSMakeRange(conditionEndIndex + 1, string.length - conditionEndIndex - 1)];
            }
            else
            {
                *withoutCondition = @""; //this means we are finished extracting conditions
            }
        }


    return condition;
}

@end
