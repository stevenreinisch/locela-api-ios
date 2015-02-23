//
// Created by steven reinisch on 20/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFDateFormatter.h"
#import "RFMessageFormatter.h"

#pragma mark - private

@interface RFDateFormatter ()

@property (nonatomic, strong)NSLocale *locale;

@end

#pragma mark -

@implementation RFDateFormatter

#pragma mark - private

- (NSRange)rangeOfIndexInPlaceholder:(NSString *)placeholder
{
    NSRange commaRange = [placeholder rangeOfString:@","];
    return NSMakeRange(1, commaRange.location);
}

- (NSRange)formatRangeFromPlaceholder:(NSString *)placeholder
{
    return [placeholder rangeOfString:@"date,"];
}

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                    format:(NSString *)format
{
    NSMutableString *mutable = [NSMutableString stringWithString:string];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale           = self.locale;
    NSDateFormatterStyle style     = kCFDateFormatterNoStyle;

    if (!format || [@"" isEqualToString:format])
    {
        style = kCFDateFormatterMediumStyle;
    }
    else if (!format || [@"short" isEqualToString:format])
    {
        style = kCFDateFormatterShortStyle;
    }
    else if (!format || [@"medium" isEqualToString:format])
    {
        style = kCFDateFormatterMediumStyle;
    }
    else if (!format || [@"long" isEqualToString:format])
    {
        style = kCFDateFormatterLongStyle;
    }
    else if (!format || [@"full" isEqualToString:format])
    {
        style = kCFDateFormatterFullStyle;
    }
    else
    {
        [dateFormatter setDateFormat:format];
    }

    if (kCFDateFormatterNoStyle != style)
    {
        [self setStyle:style  forFormatter:dateFormatter];
    }

    NSString *formattedDate = [dateFormatter stringFromDate:value];

    [mutable replaceCharactersInRange:range withString:formattedDate];

    return [NSString stringWithString:mutable];
}

- (void)setStyle:(NSDateFormatterStyle)style forFormatter:(NSDateFormatter *)formatter
{
    [formatter setDateStyle:style];
}

@end