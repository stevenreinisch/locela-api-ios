//
// Created by steven reinisch on 17/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This is the base class for formatter implementations.
 * This class provides a template (http://en.wikipedia.org/wiki/Template_method_pattern)
 * for replacing a placeholder in a message. A placeholder is a string that starts with '{'
 * and ends with '}' - e.g. {0} or {0, date, someDateFormatSpecifier}.
 * Subclasses must provide implementations for getting the value index, getting the
 * format specifier, and replacing the placeholder with a formatted value.
 */
@interface RFBaseFormatter : NSObject

- (instancetype)initWithLocale:(NSLocale *)locale NS_DESIGNATED_INITIALIZER;

- (BOOL)replaceFirstPlaceholderInMessage:(NSString *)message
                                   match:(NSTextCheckingResult *)match
                                  values:(NSArray *)values
                                  result:(NSString **)result
                                   error:(NSError **)error;

#pragma mark - protected

@property (nonatomic, strong) NSLocale *locale;

/*
 * Returns the index in a placeholder string.
 * E.g. indexFromPlaceholder:@"{0}" returns 0
 */
- (NSInteger)indexFromPlaceholder:(NSString *)placeholder;

/*
 * Returns the range of the index in a placeholder string.
 */
- (NSRange)rangeOfIndexInPlaceholder:(NSString *)placeholder;

/*
 * Returns the format from a placeholder string.
 * E.g. formatFromPlaceholder:@"{0,time,short}" returns @"short"
 */
- (NSString *)formatFromPlaceholder:(NSString *)placeholder;

/*
 * Returns the range of the format string in a placeholder string
 */
- (NSRange)formatRangeFromPlaceholder:(NSString *)placeholder;

/*
 * Replace a value in a string at a range with the given format
 */
- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                    format:(NSString *)format;

@end