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
    NSString *fileName = [self localizationPatternFileName];
    NSString *path     = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"properties"];

    NSString *text = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    PropertyParser *propertyParser = [[PropertyParser alloc] init];
    NSDictionary *keyValueMap      = [propertyParser parse:text];


    return keyValueMap;
}

- (NSString *)localizationPatternFileName
{
    return nil;
}

@end