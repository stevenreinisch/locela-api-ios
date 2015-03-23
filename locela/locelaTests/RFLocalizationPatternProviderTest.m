//
//  RFLocalizationPatternProviderTest.m
//  Locela
//
//  Created by steven reinisch on 23/03/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFLocalizationPatternProvider.h"

#pragma mark - private declarations

@interface RFLocalizationPatternProvider (Testing)

- (NSString *)localizationPatternFileName;

@end

#pragma mark -

@interface RFLocalizationPatternProviderTest : XCTestCase

@property (nonatomic, strong)RFLocalizationPatternProvider *sut;

- (NSString *)localizationPatternFileName;

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

- (void)testLocalizationPatternFileName
{
    NSString *fileName = [self.sut localizationPatternFileName];

    NSString *expected = [NSString stringWithFormat:@"%@", [NSLocale currentLocale]];

    XCTAssertEqualObjects(expected, fileName);
}

@end
