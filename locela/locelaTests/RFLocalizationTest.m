//
//  RFLocalizationTest.m
//  Locela
//
//  Created by steven reinisch on 23/03/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RFLocalization.h"
#import "RFLocalizationPatternProvider.h"
#import "RFMessageFormatter.h"

#pragma mark - private declarations

@interface RFLocalization (Testing)

@property(nonatomic, strong) RFLocalizationPatternProvider *patternProvider;
@property(nonatomic, strong) NSDictionary                  *patterns;
@property(nonatomic, strong) NSLocale                      *currentLocale;

@end

#pragma mark -

@interface RFLocalizationTest : XCTestCase

@property (nonatomic, strong) RFLocalization *sut;

@end

#pragma mark -

@implementation RFLocalizationTest

- (void)setUp
{
    [super setUp];


}

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

    NSLocale *currentLocale    = [NSLocale currentLocale];
    OCMStub([patternProviderMock currentLocale]).andReturn(currentLocale);

    //call sut
    self.sut = [[RFLocalization alloc] initWithPatternProvider:patternProviderMock];

    XCTAssertEqualObjects(self.sut.patternProvider, patternProviderMock);
    XCTAssertEqualObjects(self.sut.patterns, testPatterns);
    XCTAssertEqualObjects(self.sut.currentLocale, currentLocale);
}

#pragma mark - format

- (void)testFormat
{
    NSDictionary *testPatterns = @{ @"greeting" : @"Hello {0}" };
    id patternProviderMock     = OCMClassMock([RFLocalizationPatternProvider class]);
    OCMStub([patternProviderMock patternsForCurrentLocale]).andReturn(testPatterns);

    self.sut = [[RFLocalization alloc] initWithPatternProvider:patternProviderMock];

    //call sut
    NSString *formattedMessage = [self.sut format:@"greeting" values:@[@"Peter"]];

    XCTAssertEqualObjects(@"Hello Peter", formattedMessage);
}

@end
