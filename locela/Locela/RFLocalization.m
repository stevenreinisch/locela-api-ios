//
// Created by steven reinisch on 23/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFLocalization.h"
#import "RFLocalizationPatternProvider.h"
#import "RFMessageFormatter.h"

#pragma mark - private

@interface RFLocalization ()

@property(nonatomic, strong) RFLocalizationPatternProvider *patternProvider;
@property(nonatomic, strong) NSDictionary                  *patterns;
@property(nonatomic, strong) NSLocale                      *currentLocale;

@end

#pragma mark -

@implementation RFLocalization

- (instancetype)initWithPatternProvider:(RFLocalizationPatternProvider *)patternProvider
{
    self = [super init];

    if (self)
    {
        _patternProvider = patternProvider;
        _currentLocale   = [patternProvider currentLocale];
        _patterns        = [patternProvider patternsForCurrentLocale];
    }

    return self;
}

- (NSString *)format:(NSString *)key values:(NSArray *)values
{
    NSString *formattedMessage = nil;

    NSString *pattern = [self.patterns objectForKey:key];

    if (pattern)
    {
        RFMessageFormatter * formatter = [[RFMessageFormatter alloc] initWithLocale:self.currentLocale
                                                                            pattern:pattern];
        formattedMessage = [formatter format:values];
    }

    return formattedMessage;
}

@end