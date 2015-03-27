//
// Created by steven reinisch on 23/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RFLocalizationPatternProvider : NSObject

- (NSLocale *)currentLocale;

- (NSDictionary *)patternsForCurrentLocale;

- (NSDictionary *)patternsForLocale:(NSLocale *)locale;

- (NSArray *)fallbackLocalesForLocale:(NSLocale *)locale;

@end