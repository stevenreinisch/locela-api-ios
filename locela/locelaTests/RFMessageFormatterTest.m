//
//  RFMessageFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 13/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFMessageFormatter.h"

#pragma mark - private formward declarations

@interface RFMessageFormatter (Testing)

@property (nonatomic, strong) NSLocale *locale;

- (NSArray *)values:(id)firstValue, ...;
- (NSInteger)indexFromPlaceholder:(NSString *)placeholder;
- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range;

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
}

- (void)testInitWithLocaleNotNil {

    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];

    self.sut = [[RFMessageFormatter alloc] initWithLocale:locale];

    XCTAssertEqualObjects(locale, self.sut.locale, @"locale must match given locale");
}

#pragma mark - formatPattern:values

- (void)testFormatPatternValuesOneString
{
    NSString *result = [self.sut formatPattern:@"Hello {0}!"
                                        values:@"Klaus", nil];

    XCTAssertEqualObjects(@"Hello Klaus", result);
}

#pragma mark - values:

- (void)testValuesNoValue
{
    NSArray *values = [self.sut values:nil];

    XCTAssertEqual([values count], 0);
}

- (void)testValuesMultipleValues
{
    id value1 = @"Foo";
    id value2 = @(3);

    NSArray *values = [self.sut values:value1, value2, nil];
    
    XCTAssertEqual([values count], 2);
    XCTAssertEqualObjects(value1, values[0]);
    XCTAssertEqualObjects(value2, values[1]);
}

#pragma mark - indexFromPlaceholder:

- (void)testIndexFromPlaceholder
{
    NSInteger index = [self.sut indexFromPlaceholder:@"{3}"];
    XCTAssertEqual(index, 3);
    
    index = [self.sut indexFromPlaceholder:@"{-1}"];
    XCTAssertEqual(index, -1);
}

- (void)testIndexFromPlaceholderNoIndex
{
    NSInteger index = [self.sut indexFromPlaceholder:@"{a}"];
    XCTAssertEqual(index, NSIntegerMin);
    
    index = [self.sut indexFromPlaceholder:@"{}"];
    XCTAssertEqual(index, NSIntegerMin);
}

- (void)testIndexFromPlaceholderNil
{
    NSInteger index = [self.sut indexFromPlaceholder:nil];
    XCTAssertEqual(index, NSIntegerMin);
}

- (void)testIndexFromPlaceholderEmptyString
{
    NSInteger index = [self.sut indexFromPlaceholder:@""];
    XCTAssertEqual(index, NSIntegerMin);
}

#pragma mark - replaceValue:inString:inRange

- (void)testReplaceValueInStringInRange
{
    NSString *string = @"Hello X";
    NSString *value  = @"Peter";
    NSRange  range   = NSMakeRange(string.length - 1, 1);

    NSString *result = [self.sut replaceValue:value
                                     inString:string
                                      inRange:range];

    XCTAssertEqualObjects(result, @"Hello Peter");
}


@end