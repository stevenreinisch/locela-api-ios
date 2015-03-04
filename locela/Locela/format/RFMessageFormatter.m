//
// Created by steven reinisch on 13/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFMessageFormatter.h"
#import "RFStringFormatter.h"
#import "RFNumberFormatter.h"
#import "RFValueFormatter.h"
#import "RFDateFormatter.h"
#import "RFTimeFormatter.h"
#import "RFDatetimeFormatter.h"
#import "RFChoiceFormatter.h"
#import "RFRegExpUtil.h"

#pragma mark - constants

NSString *const kRFMessageFormatterErrorDomain = @"RFMessageFormatterError";

NSString *const kRFMessageFormatterSimplePlaceholderPattern   = @"\\{\\d\\}";
NSString *const kRFMessageFormatterNumberPlaceholderPattern   = @"\\{\\d,\\s*number(,\\s*.+)?\\}";
NSString *const kRFMessageFormatterDatePlaceholderPattern     = @"\\{\\d,\\s*date(,\\s*.+)?\\}";
NSString *const kRFMessageFormatterTimePlaceholderPattern     = @"\\{\\d,\\s*time(,\\s*.+)?\\}";
NSString *const kRFMessageFormatterDatetimePlaceholderPattern = @"\\{\\d,\\s*datetime(,\\s*.+)?\\}";
NSString *const kRFMessageFormatterChoicePlaceholderPattern   = @"\\{\\d,\\s*choice(,\\s*.+)\\}";

#pragma mark - private

@interface RFMessageFormatter ()

@property (nonatomic, strong) NSLocale *locale;

/*
 * key: regular expression
 * value: formatter
 */
@property (nonatomic, strong) NSDictionary *formatterClasses;

@end

#pragma mark -

@implementation RFMessageFormatter

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

        _formatterClasses = @{
                kRFMessageFormatterSimplePlaceholderPattern   : [RFStringFormatter class],
                kRFMessageFormatterNumberPlaceholderPattern   : [RFNumberFormatter class],
                kRFMessageFormatterDatePlaceholderPattern     : [RFDateFormatter class],
                kRFMessageFormatterTimePlaceholderPattern     : [RFTimeFormatter class],
                kRFMessageFormatterDatetimePlaceholderPattern : [RFDatetimeFormatter class],
                kRFMessageFormatterChoicePlaceholderPattern   : [RFChoiceFormatter class]
        };
    }
    return self;
}

#pragma mark -

- (BOOL)formatPattern:(NSString *)pattern
               values:(NSArray *)values
               result:(NSString **)result
                error:(NSError **)error
{
    return [self replaceFirstPlaceholderInPattern:pattern
                                      usingValues:values
                                           result:result
                                            error:error];
}

#pragma mark - private

- (BOOL)              findFormatter:(RFValueFormatter **)formatter
        forFirstPlaceholderInString:(NSString *)string
                             result:(NSTextCheckingResult **)result
                              error:(NSError **)error
{
    NSString *regExp            = nil;
    NSEnumerator *enumerator    = [self.formatterClasses keyEnumerator];

    //find the formatter for the given pattern
    while (!*result && (regExp = [enumerator nextObject]))
    {
        BOOL regExpOk = [RFRegExpUtil matchString:string
                             againstRegExpPattern:regExp
                                            match:result
                                            error:error];

        if (!regExpOk)//The regExp might be malformed.
        {
            return NO;
        }
    }

    if (*result)//There is a match for regExp
    {
        Class formatterClass = [self.formatterClasses objectForKey:regExp];

        if (!formatterClass)//Found a match but there's no formatter
        {
            *error = [NSError errorWithDomain:kRFMessageFormatterErrorDomain
                                         code:RFMessageFormatterErrorCodeNoMatchingFormatter
                                     userInfo:@{ @"regExp" : regExp }];

            return NO;
        }

        *formatter = [[formatterClass alloc] initWithLocale:self.locale];
    }

    return YES;//no error
}

- (BOOL)replaceFirstPlaceholderInPattern:(NSString *)pattern
                             usingValues:(NSArray *)values
                                  result:(NSString **)result
                                   error:(NSError **)error
{
    RFValueFormatter *formatter       = nil;
    NSTextCheckingResult *matchResult = nil;

    BOOL callOk = [self                 findFormatter:&formatter
                          forFirstPlaceholderInString:pattern
                                               result:&matchResult
                                                error:error];

    if (!callOk) //something went wrong finding a matching formatter
    {
        return NO;
    }

    //no match, no formatter, no error => no more placeholders to replace
    if (!matchResult && !formatter)
    {
        *result = [pattern copy];
        return YES;
    }

    //We have a match and a formatter. Let it do its job!
    NSString *formatResult = nil;
    BOOL formattingOk = [formatter formatFirstValuePlaceholderInString:pattern
                                                                 match:matchResult
                                                                values:values
                                                                result:&formatResult
                                                                 error:error];

    if (!formattingOk)//something went wrong while formatting the placeholder
    {
        return NO;
    }

    //Recursively proceed with other value placeholders
    return [self replaceFirstPlaceholderInPattern:formatResult
                                      usingValues:values
                                           result:result
                                            error:error];
}

@end