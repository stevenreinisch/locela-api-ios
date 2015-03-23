//
// Created by steven reinisch on 23/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFLocalizationPatternProvider;


@interface RFLocalization : NSObject

- (instancetype)initWithPatternProvider:(RFLocalizationPatternProvider *)patternProvider NS_DESIGNATED_INITIALIZER;

- (NSString *)format:(NSString *)key values:(NSArray *)values;

@end