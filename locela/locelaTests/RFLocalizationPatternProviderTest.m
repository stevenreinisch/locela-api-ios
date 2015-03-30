//
//  RFLocalizationPatternProviderTest.m
//  Locela
//
//  Created by steven reinisch on 23/03/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RFLocalizationPatternProvider.h"

#pragma mark - private declarations

@interface RFLocalizationPatternProvider (Testing)

- (NSString *)localizationPatternFileNameForLocale:(NSLocale *)locale;
- (NSDictionary *)loadDictFromPropertiesFileWithName:(NSString *)fileName;

@end

#pragma mark -

@interface RFLocalizationPatternProviderTest : XCTestCase

@property (nonatomic, strong)RFLocalizationPatternProvider *sut;

@end

#pragma mark -

@implementation RFLocalizationPatternProviderTest

- (void)setUp
{
    [super setUp];

    self.sut = [[RFLocalizationPatternProvider alloc] init];
}

- (void)tearDown
{
    self.sut = nil;

    [super tearDown];
}

#pragma mark - tests

#pragma mark - currentLocale

- (void)testCurrentLocale
{
    NSLocale *locale = [self.sut currentLocale];
    XCTAssertEqualObjects([NSLocale currentLocale], locale);
}

#pragma mark - localizationPatternFileName

- (void)testLocalizationPatternFileNameForLocale
{
    NSString *fileName = [self.sut localizationPatternFileNameForLocale:[NSLocale currentLocale]];

    NSString *expected = [NSString stringWithFormat:@"%@", [[NSLocale currentLocale] localeIdentifier]];

    XCTAssertEqualObjects(expected, fileName, @"name of file must be the identifier of the corresponding locale");
}

#pragma mark - patternsForCurrentLocale

- (void)testPatternsForCurrentLocale
{
    id sutMock = OCMPartialMock(self.sut);
    [[sutMock expect] patternsForLocale:[NSLocale currentLocale]];

    //call sut
    [self.sut patternsForCurrentLocale];

    [sutMock verify];
    [sutMock stopMocking];
}

#pragma mark - patternsForLocale

- (void)testPatternsForLocale
{
    NSLocale *locale = [NSLocale currentLocale];
    NSDictionary *expectedResult = @{ @"test" : @"foo" };

    id sutMock = OCMPartialMock(self.sut);

    OCMExpect([sutMock localizationPatternFileNameForLocale:locale]).andReturn(@"testFile");
    OCMExpect([sutMock loadDictFromPropertiesFileWithName:@"testFile"]).andReturn(expectedResult);

    //call sut
    NSDictionary *actualResult = [self.sut patternsForLocale:locale];

    XCTAssertEqualObjects(actualResult, expectedResult);
    OCMVerifyAll(sutMock);
    [sutMock stopMocking];
}

#pragma mark - loadDictFromPropertiesFileWithName

- (void)testLoadDictFromPropertiesFileWithName
{
    XCTFail(@"not done yet");
}

@end
