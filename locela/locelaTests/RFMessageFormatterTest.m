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
                                        values:@[@"Klaus"]];

    XCTAssertEqualObjects(@"Hello Klaus!", result);
}

- (void)testFormatPatternValuesTwoStringsInOrder
{
    NSString *result = [self.sut formatPattern:@"Hello {0} you are {1}!"
                                        values:@[@"Klaus", @"awesome"]];
    
    XCTAssertEqualObjects(@"Hello Klaus you are awesome!", result);
}

- (void)testFormatPatternValuesTwoStringsNotInOrder
{
    NSString *result = [self.sut formatPattern:@"Hello {1} you are {0}!"
                                        values:@[@"Klaus", @"awesome"]];
    
    XCTAssertEqualObjects(@"Hello awesome you are Klaus!", result);
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
