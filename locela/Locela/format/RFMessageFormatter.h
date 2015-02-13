//
// Created by steven reinisch on 13/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - constants

extern NSString *const kRFMessageFormatterErrorDomain;

typedef NS_ENUM(NSUInteger, RFMessageFormatterErrorCode) {
    RFMessageFormatterErrorCodeCannotCreateRegExp,
    RFMessageFormatterErrorCodeNoValueAtIndex
};

#pragma mark -

@interface RFMessageFormatter : NSObject

- (instancetype)initWithLocale:(NSLocale *)locale NS_DESIGNATED_INITIALIZER;

- (BOOL)formatPattern:(NSString *)pattern
               values:(NSArray *)values
               result:(NSString **)result
                error:(NSError **)error;

@end