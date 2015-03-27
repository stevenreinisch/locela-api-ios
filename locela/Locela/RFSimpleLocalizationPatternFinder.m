//
// Created by steven reinisch on 27/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFSimpleLocalizationPatternFinder.h"
#import "RFLocalizationPatternProvider.h"

#pragma mark - private

@interface RFSimpleLocalizationPatternFinder ()

@property(nonatomic, strong) NSDictionary *patterns;

@end

#pragma mark -

@implementation RFSimpleLocalizationPatternFinder

- (instancetype)initWithPatternProvider:(RFLocalizationPatternProvider *)patternProvider
{
    self = [super initWithPatternProvider:patternProvider];

    if (self)
    {
        _patterns = [self.patternProvider patternsForCurrentLocale];
    }
    return self;
}

- (NSString *)findPatternForKey:(NSString *)key
{
    return [self.patterns objectForKey:key];
}

@end