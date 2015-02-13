//
// Created by steven reinisch on 13/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFMessageFormatter.h"

#pragma mark - private

@interface RFMessageFormatter ()

@property (nonatomic, strong) NSLocale *locale;

@end

#pragma mark -

@implementation RFMessageFormatter

- (instancetype)initWithLocale:(NSLocale *)locale
{
    self = [super init];

    if (self)
    {
        if (!locale)
        {
            _locale = [NSLocale currentLocale];
        }
        else
        {
            _locale = locale;
        }
    }
    return self;
}

@end