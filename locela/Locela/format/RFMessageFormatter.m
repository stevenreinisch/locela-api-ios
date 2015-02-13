//
// Created by steven reinisch on 13/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFMessageFormatter.h"

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

- (NSString *)formatPattern:(NSString *)pattern
                     values:(id)firstValue, ...
{

    NSArray *values = [self values:firstValue];

    NSError *error = NULL;
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSString *regExpPattern = @"\\{\\d\\}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExpPattern
                                                                           options:regexOptions
                                                                             error:&error];
    if (error)
    {
        NSLog(@"Couldn't create regex with given string and options");
    }

    __block NSString *formattedPattern = [pattern copy];

    [regex enumerateMatchesInString:pattern
                            options:0
                              range:NSMakeRange(0, pattern.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {

         NSString *placeholder = [pattern substringWithRange:result.range];
         NSInteger index = [self indexFromPlaceholder:placeholder];
         if (0 <= index && index < [values count])
         {
             id value = values[index];
             formattedPattern = [self replaceValue:value
                                          inString:formattedPattern
                                           inRange:result.range];

         }
     }];

    return formattedPattern;
}

#pragma mark - private

- (NSArray *)values:(id)firstValue, ...
{
    NSMutableArray *values = [[NSMutableArray alloc] init];//get from arg list

    if (!firstValue)
    {
        return values;
    }
    
    va_list args;
    va_start(args, firstValue);

    id value = firstValue;
    do
    {
        [values addObject:value];
    }
    while( (value = va_arg(args, id)) );

    va_end(args);

    return values;
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