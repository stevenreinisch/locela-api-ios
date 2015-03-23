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

- (NSString *)localizationPatternFileNameForLocale:(NSLocale *)locale;

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

    XCTAssertEqualObjects(expected, fileName);
}

@end
