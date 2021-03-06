//
// Created by steven reinisch on 13/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - constants

extern NSString *const kRFMessageFormatterErrorDomain;

typedef NS_ENUM(NSUInteger, RFMessageFormatterErrorCode) {
    RFMessageFormatterErrorCodeCannotCreateRegExp,
    RFMessageFormatterErrorCodeNoValueAtIndex,
    RFMessageFormatterErrorCodeNoMatchingFormatter
};

#pragma mark -

@interface RFMessageFormatter : NSObject

- (instancetype)initWithLocale:(NSLocale *)locale
                       pattern:(NSString *)pattern NS_DESIGNATED_INITIALIZER;

- (NSString *)format:(NSArray *)values;

@end