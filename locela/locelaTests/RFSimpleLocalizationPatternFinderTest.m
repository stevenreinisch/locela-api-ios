//
//  RFSimpleLocalizationPatternFinderTest.m
//  Locela
//
//  Created by steven reinisch on 27/03/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RFSimpleLocalizationPatternFinder.h"
#import "RFLocalizationPatternProvider.h"

#pragma mark - private declarations

@interface RFSimpleLocalizationPatternFinder (Testing)

@property(nonatomic, strong) NSDictionary *patterns;

@end

#pragma mark -

@interface RFSimpleLocalizationPatternFinderTest : XCTestCase

@property (nonatomic, strong) RFSimpleLocalizationPatternFinder *sut;

@end

#pragma mark -

@implementation RFSimpleLocalizationPatternFinderTest

- (void)tearDown
{
    self.sut = nil;

    [super tearDown];
}

#pragma mark - tests

- (void)testInitWithPatternProvider
{
    //mock the pattern provider
    NSDictionary *testPatterns = [NSDictionary dictionary];

    id patternProviderMock     = OCMClassMock([RFLocalizationPatternProvider class]);
    OCMStub([patternProviderMock patternsForCurrentLocale]).andReturn(testPatterns);
    
    //call sut
    self.sut = [[RFSimpleLocalizationPatternFinder alloc] initWithPatternProvider:patternProviderMock];

    XCTAssertEqualObjects(self.sut.patternProvider, patternProviderMock);
    XCTAssertEqualObjects(self.sut.patterns, testPatterns);
}

#pragma - findPatternForKey:

- (void)testFindPatternForKey
{
    //mock the pattern provider
    NSDictionary *testPatterns = @{ @"test" : @"testPattern" };

    id patternProviderMock     = OCMClassMock([RFLocalizationPatternProvider class]);
    OCMStub([patternProviderMock patternsForCurrentLocale]).andReturn(testPatterns);

    self.sut = [[RFSimpleLocalizationPatternFinder alloc] initWithPatternProvider:patternProviderMock];

    //call sut
    NSString *pattern = [self.sut findPatternForKey:@"test"];

    XCTAssertEqualObjects(@"testPattern", pattern);
}

@end
