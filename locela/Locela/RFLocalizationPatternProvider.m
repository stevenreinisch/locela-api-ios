//
// Created by steven reinisch on 23/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFLocalizationPatternProvider.h"
#import <BNFParser/PropertyParser.h>

@implementation RFLocalizationPatternProvider

- (NSLocale *)currentLocale
{
    return [NSLocale currentLocale];
}

- (NSDictionary *)patternsForCurrentLocale
{
    return [self patternsForLocale:[self currentLocale]];
}

- (NSDictionary *)patternsForLocale:(NSLocale *)locale
{
    NSString *fileName   = [self localizationPatternFileNameForLocale:locale];
    NSDictionary *result = [self loadDictFromPropertiesFileWithName:fileName];
    return result;
}

- (NSArray *)fallbackLocalesForLocale:(NSLocale *)locale
{
    return [self loadDictFromPropertiesFileWithName:@"fallbackLocales"];
}

#pragma mark - private

- (NSString *)localizationPatternFileNameForLocale:(NSLocale *)locale
{
    return [NSString stringWithFormat:@"%@", [locale localeIdentifier]];
}

- (NSDictionary *)loadDictFromPropertiesFileWithName:(NSString *)fileName
{
    NSDictionary *keyValueMap = nil;

    if (fileName)
    {
        NSString *contents = [self contentsOfFile:fileName];

        if (contents)
        {
            PropertyParser *propertyParser = [[PropertyParser alloc] init];
            keyValueMap = [propertyParser parse:contents];
        }
    }
    return keyValueMap;
}

- (NSString *)contentsOfFile:(NSString *)fileName
{
    NSString *contents = nil;

    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"properties"];
    if (path)
    {
        contents = [NSString stringWithContentsOfFile:path
                                             encoding:NSUTF8StringEncoding
                                                error:nil];
    }

    return contents;
}

@end