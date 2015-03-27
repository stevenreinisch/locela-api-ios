//
// Created by steven reinisch on 27/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFBaseLocalizationPatternFinder.h"
#import "RFUtils.h"

@implementation RFBaseLocalizationPatternFinder

- (instancetype)initWithPatternProvider:(RFLocalizationPatternProvider *)patternProvider
{
    self = [super init];

    if (self)
    {
        _patternProvider = patternProvider;
    }
    return self;
}

- (NSString *)findPatternForKey:(NSString *)key RF_ABSTRACT_METHOD(nil)

@end