//
// Created by steven reinisch on 27/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFLocalizationPatternProvider;

@protocol RFLocalizationPatternFinder <NSObject>

- (instancetype)initWithPatternProvider:(RFLocalizationPatternProvider *)patternProvider;

- (NSString *)findPatternForKey:(NSString *)key;

@end