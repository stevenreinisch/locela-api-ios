//
// Created by steven reinisch on 13/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFMessageFormatter.h"

#pragma mark - constants

NSString *const kRFMessageFormatterErrorDomain = @"RFMessageFormatterError";

#pragma mark - private

@interface RFMessageFormatter ()

@property (nonatomic, strong) NSLocale *locale;

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

- (BOOL)replaceFirstPlaceholderInPattern:(NSString *)pattern
                             usingValues:(NSArray *)values
                                  result:(NSString **)result
                                   error:(NSError **)error
{
    NSError                    *regexError   = NULL;
    NSRegularExpressionOptions regexOptions  = NSRegularExpressionCaseInsensitive;
    NSString                   *regExPattern = @"\\{\\d\\}";
    NSRegularExpression        *regex        = [NSRegularExpression regularExpressionWithPattern:regExPattern
                                                                                         options:regexOptions
                                                                                           error:&regexError];
    if (regexError)
    {
        NSLog(@"Couldn't create regex with given string and options");

        *error = [NSError errorWithDomain:kRFMessageFormatterErrorDomain
                                     code:RFMessageFormatterErrorCodeCannotCreateRegExp
                                 userInfo:@{}];

        return NO;
    }

    NSTextCheckingResult *match = [regex firstMatchInString:pattern
                                                    options:0
                                                      range:NSMakeRange(0, pattern.length)];

    NSString *replacedPattern = [pattern copy];
    
    if (match)
    {
        NSString  *placeholder = [pattern substringWithRange:match.range];
        NSInteger index        = [self indexFromPlaceholder:placeholder];

        if (0 <= index && index < [values count])
        {
            id       value  = values[index];
            replacedPattern = [self replaceValue:value
                                        inString:pattern
                                         inRange:match.range];

            return [self replaceFirstPlaceholderInPattern:replacedPattern
                                              usingValues:values
                                                   result:result
                                                    error:error];
        }
        else
        {
            *error = [NSError errorWithDomain:kRFMessageFormatterErrorDomain
                                         code:RFMessageFormatterErrorCodeNoValueAtIndex
                                     userInfo:@{ @"index" : @(index) }];
            
            return NO;
        }
    }
    else
    {
        *result = [NSString stringWithString:replacedPattern];
        return YES;
    }
}


- (NSInteger)indexFromPlaceholder:(NSString *)placeholder
{
    NSRange   range        = NSMakeRange(1, placeholder.length - 1);
    NSString  *parsedIndex = [placeholder substringWithRange:range];
    NSScanner *scanner     = [NSScanner scannerWithString:parsedIndex];
    int       scannedIndex = -1;
    BOOL      isInt        = [scanner scanInt:&scannedIndex];

    if (isInt)
    {
        return scannedIndex;
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