//
//  RFHierarchicalLocalizationPatternFinderTest.m
//  Locela
//
//  Created by steven reinisch on 30/03/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RFHierarchicalLocalizationPatternFinder.h"
#import "RFLocalizationPatternProvider.h"

@interface RFHierarchicalLocalizationPatternFinderTest : XCTestCase

@property (nonatomic, strong) RFHierarchicalLocalizationPatternFinder *sut;

@end

@implementation RFHierarchicalLocalizationPatternFinderTest

- (void)tearDown
{
    self.sut = nil;

    [super tearDown];
}

#pragma mark - tests

- (void)testFindPatternForKey
{
    NSLocale *currentLocale  = [NSLocale localeWithLocaleIdentifier:@"de-CH"];
    NSLocale *germany        = [NSLocale localeWithLocaleIdentifier:@"de-DE"];
    NSLocale *us             = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    NSLocale *gb             = [NSLocale localeWithLocaleIdentifier:@"en-GB"];
    NSArray *fallbackLocales = @[germany, us, gb];

    NSDictionary *patternsForCurrentLocale = @{ @"foo"     : @"yesssss" };
    NSDictionary *patternsForDELocale      = @{ @"bar"     : @"ohhhhh yesssss" };
    NSDictionary *patternsForUSLocale      = @{ @"Service" : @"Wimp" };
    NSDictionary *patternsForGBLocale      = @{ @"Service" : @"Womp" };

    //stub relevant methods on patternProvider
    id patternProviderMock = OCMClassMock([RFLocalizationPatternProvider class]);
    OCMStub([patternProviderMock currentLocale]).andReturn(currentLocale);
    OCMStub([patternProviderMock fallbackLocalesForLocale:currentLocale]).andReturn(fallbackLocales);
    OCMStub([patternProviderMock patternsForLocale:currentLocale]).andReturn(patternsForCurrentLocale);
    OCMStub([patternProviderMock patternsForLocale:germany]).andReturn(patternsForDELocale);
    OCMStub([patternProviderMock patternsForLocale:us]).andReturn(patternsForUSLocale);
    OCMStub([patternProviderMock patternsForLocale:gb]).andReturn(patternsForGBLocale);

    //create sut
    self.sut = [[RFHierarchicalLocalizationPatternFinder alloc] initWithPatternProvider:patternProviderMock];

    //call sut
    NSString *pattern = [self.sut findPatternForKey:@"Service"];

    XCTAssertEqualObjects(@"Wimp", pattern);
}

@end
