//
// Created by steven reinisch on 27/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFHierarchicalLocalizationPatternFinder.h"
#import "RFLocalizationPatternProvider.h"

#pragma mark - private

@interface RFHierarchicalLocalizationPatternFinder ()

@end

#pragma mark -

@implementation RFHierarchicalLocalizationPatternFinder

- (NSString *)findPatternForKey:(NSString *)key
{
    NSString *pattern = [super findPatternForKey:key];

    if (!pattern)
    {
        NSLocale *locale        = self.patternProvider.currentLocale;
        NSEnumerator *fallbacks = [[self.patternProvider fallbackLocalesForLocale:locale] objectEnumerator];

        while (!pattern && (locale = [fallbacks nextObject]))
        {
            NSDictionary *patterns = [self.patternProvider patternsForLocale:locale];
            pattern = [patterns objectForKey:key];
        }
    }

    return pattern;
}

@end
