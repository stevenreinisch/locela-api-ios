//
//  NSNumberFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 16/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

/*
 * This test case is used to check which formats
 * are supported by NSNumberFormatter
 */
@interface NSNumberFormatterTest : XCTestCase

@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, copy)   NSString *formattedText;

@end

@implementation NSNumberFormatterTest

- (void)setUp {
    [super setUp];

    self.num = [NSNumber numberWithDouble:1235];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.formattedText = nil;
}

- (void)tearDown {

    self.num = nil;
    self.numberFormatter = nil;
    self.formattedText = nil;

    [super tearDown];
}

#pragma mark - test

#define ASSERT_FORMAT(format, expected, message) [self.numberFormatter setPositiveFormat:format];\
                                                 self.formattedText = [self.numberFormatter stringFromNumber:self.num];\
                                                 XCTAssertEqualObjects(expected, self.formattedText, message);\

- (void)testRequiredDigits
{
    ASSERT_FORMAT(@"0",     @"1235", @"requiredDigits#1")
    ASSERT_FORMAT(@"00",    @"1235", @"requiredDigits#2")
    ASSERT_FORMAT(@"000",   @"1235", @"requiredDigits#3")
    ASSERT_FORMAT(@"0000",  @"1235", @"requiredDigits#4")
    ASSERT_FORMAT(@"00000", @"01235", @"requiredDigits#5")
}

- (void)testOptionalDigits
{
    ASSERT_FORMAT(@"#0000",     @"1235", @"optionalDigits#1")
    ASSERT_FORMAT(@"##000",     @"1235", @"optionalDigits#2")
}

- (void)testMinusSign
{
    ASSERT_FORMAT(@"-0", @"-1235", @"minusSign#1")
}

- (void)testGroupingSeparator
{
    ASSERT_FORMAT(@"#,##0",    @"1,235",  @"groupingSeparator#1")
    ASSERT_FORMAT(@"##0,0000", @"0,1235", @"groupingSeparator#2")
}

- (void)testMantissaExponent
{
    ASSERT_FORMAT(@"0E0",    @"1E3",    @"mantissaExponent1")
    ASSERT_FORMAT(@"0E00",   @"1E03",   @"mantissaExponent2")
    ASSERT_FORMAT(@"0E000",  @"1E003",  @"mantissaExponent3")
    ASSERT_FORMAT(@"0E0000", @"1E0003", @"mantissaExponent4")
    ASSERT_FORMAT(@"0.00E0", @"1.24E3", @"mantissaExponent5")
}

- (void)testPercentage
{
    self.num = [NSNumber numberWithDouble:0.75];

    ASSERT_FORMAT(@"%0.00", @"%75.00",    @"percentage1")
    ASSERT_FORMAT(@"0.00%", @"75.00%",   @"percentage2")
}

- (void)testMilli
{
    self.num = [NSNumber numberWithDouble:0.75];

    ASSERT_FORMAT(@"‰0.00", @"‰750.00", @"milli1")
    ASSERT_FORMAT(@"0.00‰", @"750.00‰", @"milli2")
}

- (void)testCurrency
{
    ASSERT_FORMAT(@"¤0.00", @"$1235.00", @"currency1")
    ASSERT_FORMAT(@"0.00¤", @"1235.00$", @"currency2")
}

- (void)testSpecialChars
{
    ASSERT_FORMAT(@"0''''", @"1235'", @"specialChars1")
    ASSERT_FORMAT(@"0''#0E%‰¤''", @"1235#0E%‰¤", @"specialChars2")
}

@end
