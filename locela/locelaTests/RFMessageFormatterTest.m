//
//  RFMessageFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 13/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFMessageFormatter.h"
#import "RFStringFormatter.h"
#import "RFNumberFormatter.h"
#import "RFDateFormatter.h"

#pragma mark - private forward declarations

@interface RFMessageFormatter (Testing)

@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, strong) NSDictionary *formatterClasses;

@end

#pragma mark -

@interface RFMessageFormatterTest : XCTestCase

@property (nonatomic, strong) RFMessageFormatter *sut;

@end

#pragma mark - tests

@implementation RFMessageFormatterTest

- (void)setUp {
    [super setUp];

    NSLocale *currentLocale = [NSLocale currentLocale];
    self.sut = [[RFMessageFormatter alloc] initWithLocale:currentLocale];
}

- (void)tearDown {

    [super tearDown];
}

#pragma mark - tests

#pragma mark - initWithLocale:

- (void)testInitWithLocaleNil {

    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil];

    XCTAssertEqualObjects([NSLocale currentLocale], self.sut.locale, @"locale must be default locale if none is given");
    XCTAssertNotNil(self.sut.formatterClasses);
}

- (void)testInitWithLocaleNotNil {

    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];

    self.sut = [[RFMessageFormatter alloc] initWithLocale:locale];

    XCTAssertEqualObjects(locale, self.sut.locale, @"locale must match given locale");
    XCTAssertNotNil(self.sut.formatterClasses);
}

#pragma mark - formatterClasses

- (void)testFormatterClassesAreCreated
{
    XCTAssertNotNil(self.sut.formatterClasses);

    Class stringFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterSimplePlaceholderPattern];
    XCTAssertEqualObjects([RFStringFormatter class], stringFormatterClass);

    Class numberFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterNumberPlaceholderPattern];
    XCTAssertEqualObjects([RFNumberFormatter class], numberFormatterClass);

    Class dateFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterDatePlaceholderPattern];
    XCTAssertEqualObjects([RFDateFormatter class], dateFormatterClass);
}

#pragma mark - formatPattern:values

- (void)testFormatPatternValuesOneString
{
    NSString *result = nil;
    NSError  *error  = nil;
    
    BOOL isFormatted = [self.sut formatPattern:@"Hello {0}!"
                                        values:@[@"Klaus"]
                                        result:&result
                                         error:&error];
    
    XCTAssertTrue(isFormatted);
    
    XCTAssertEqualObjects(@"Hello Klaus!", result);
}

- (void)testFormatPatternValuesTwoStringsInOrder
{
    NSString *result = nil;
    NSError  *error  = nil;

    BOOL isFormatted = [self.sut formatPattern:@"Hello {0} you are {1}!"
                                        values:@[@"Klaus", @"awesome"]
                                        result:&result
                                         error:&error];

    XCTAssertTrue(isFormatted);
    XCTAssertEqualObjects(@"Hello Klaus you are awesome!", result);
}

- (void)testFormatPatternValuesTwoStringsNotInOrder
{
    NSString *result = nil;
    NSError  *error  = nil;
    
    BOOL isFormatted = [self.sut formatPattern:@"Hello {1} you are {0}!"
                                        values:@[@"Klaus", @"awesome"]
                                        result:&result
                                         error:&error];
    
    XCTAssertTrue(isFormatted);
    XCTAssertEqualObjects(@"Hello awesome you are Klaus!", result);
}

- (void)testFormatPatternValuesWithCurrency
{
    NSString *result = nil;
    NSError  *error  = nil;

    BOOL isFormatted = [self.sut formatPattern:@"Please Pay {0,number,¤0.00}!"
                                        values:@[@(1.5)]
                                        result:&result
                                         error:&error];

    XCTAssertTrue(isFormatted);
    XCTAssertEqualObjects(@"Please Pay $1.50!", result);
}

@end
