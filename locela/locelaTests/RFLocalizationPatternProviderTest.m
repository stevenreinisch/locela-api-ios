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
- (NSString *)contentsOfFile:(NSString *)fileName;

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

- (void)testLoadDictFromPropertiesFileWithNameNil
{
    NSDictionary *result = [self.sut loadDictFromPropertiesFileWithName:nil];

    XCTAssertNil(result);
}

- (void)testLoadDictFromPropertiesFileWithNameResourceExistsButErroneousContent
{
    NSString *testFileName = @"testFile";

    //pretend that there is no such resource
    id sutMock = OCMPartialMock(self.sut);
    OCMExpect([sutMock contentsOfFile:testFileName]).andReturn(nil);

    NSDictionary *result = [self.sut loadDictFromPropertiesFileWithName:testFileName];

    XCTAssertNil(result);
    [sutMock verify];
    [sutMock stopMocking];
}

- (void)testLoadDictFromPropertiesFileWithName
{
    NSString *testFileName    = @"testFile";
    NSString *testFileContent = @"key = value";

    //pretend that there is no such resource
    id sutMock = OCMPartialMock(self.sut);
    OCMExpect([sutMock contentsOfFile:testFileName]).andReturn(testFileContent);

    NSDictionary *result = [self.sut loadDictFromPropertiesFileWithName:testFileName];

    XCTAssertNotNil(result);
    XCTAssertEqualObjects(@{ @"key" : @"value" }, result);
    [sutMock verify];
    [sutMock stopMocking];
}

#pragma mark - contentsOfFile

- (void)testContentsOfFileNoSuchFileResource
{
    //pretend that there is no such resource
    id bundleMock = OCMClassMock([NSBundle class]);
    OCMStub([bundleMock pathForResource:OCMOCK_ANY ofType:OCMOCK_ANY]).andReturn(nil);
    OCMStub([NSBundle mainBundle]).andReturn(bundleMock);

    NSString *result = [self.sut contentsOfFile:@"notExistingFile"];

    XCTAssertNil(result);
    [bundleMock stopMocking];
}

@end
