//
// Created by steven reinisch on 02/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFRegExpUtil.h"
#import "RFMessageFormatter.h"


@implementation RFRegExpUtil

+ (BOOL) matchString:(NSString *)string
againstRegExpPattern:(NSString *)regExPattern
               match:(NSTextCheckingResult **)match
               error:(NSError **)error
{
    NSError                    *regexError   = NULL;
    NSRegularExpressionOptions regexOptions  = NSRegularExpressionCaseInsensitive;
    NSRegularExpression        *regex        = [NSRegularExpression regularExpressionWithPattern:regExPattern
                                                                                         options:regexOptions
                                                                                           error:&regexError];
    if (regexError)
    {
        NSLog(@"Couldn't create regex with given string and options");

        *error = [NSError errorWithDomain:kRFMessageFormatterErrorDomain
                                     code:RFMessageFormatterErrorCodeCannotCreateRegExp
                                 userInfo:@{ @"pattern" : regExPattern }];

        return NO;
    }

    *match = [regex firstMatchInString:string
                               options:0
                                 range:NSMakeRange(0, string.length)];

    return YES;
}

@end