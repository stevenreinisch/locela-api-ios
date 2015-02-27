//
//  RFChoiceConditionTest.m
//  Locela
//
//  Created by steven reinisch on 27/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFChoiceCondition.h"

#pragma mark - private declarations

@interface RFChoiceCondition ()

- (NSNumber *)testToNumber;
- (NSDecimalNumber *)testToDecimal;
- (BOOL)testToBool;

@end

#pragma mark -

@interface RFChoiceConditionTest : XCTestCase

@property (nonatomic, strong)RFChoiceCondition *sut;

@end

#pragma mark -

@implementation RFChoiceConditionTest

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

- (void)testEvaluateEqualsString
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"hello"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL result = [self.sut evaluate:@"hello"];

    XCTAssertTrue(result);
}

- (void)testEvaluateEquals1
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"1"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL result = [self.sut evaluate:@1];

    XCTAssertTrue(result);
}

- (void)testEvaluateEquals0
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"0"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL result = [self.sut evaluate:@0];

    XCTAssertTrue(result);
}

- (void)testEvaluateEquals1NoNumberAsTest
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"one"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL result = [self.sut evaluate:@1];

    XCTAssertFalse(result);
}

- (void)testEvaluateEqualsTrue
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"true"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL bool_value = YES;
    NSValue *value  = [NSValue valueWithBytes:&bool_value objCType:@encode(BOOL)];

    BOOL result = [self.sut evaluate:value];

    XCTAssertTrue(result);
}

- (void)testEvaluateEqualsSimpleDecimal
{
    NSString *numString = @"1.54";

    self.sut = [[RFChoiceCondition alloc] initWithTest:numString
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL result = [self.sut evaluate:[NSDecimalNumber decimalNumberWithString:numString]];

    XCTAssertTrue(result);
}

#pragma mark - testToNumber

- (void)testTestToNumberSimpleInt
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"1"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    NSNumber *number = [self.sut testToNumber];

    XCTAssertEqualObjects(@1, number);
}

- (void)testTestToNumberMaxInt
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *valueString        = [formatter stringFromNumber:@NSIntegerMax];

    self.sut = [[RFChoiceCondition alloc] initWithTest:valueString
                                              operator:'#'
                                            subPattern:@"subPattern"];

    NSNumber *number = [self.sut testToNumber];

    XCTAssertEqualObjects(@NSIntegerMax, number);
}

- (void)testTestToNumberMinInt
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *valueString        = [formatter stringFromNumber:@NSIntegerMin];

    self.sut = [[RFChoiceCondition alloc] initWithTest:valueString
                                              operator:'#'
                                            subPattern:@"subPattern"];

    NSNumber *number = [self.sut testToNumber];

    XCTAssertEqualObjects(@NSIntegerMin, number);
}

#pragma mark - testToDecimal

- (void)testTestToDecimal
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"1.54"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    NSNumber *number = [self.sut testToDecimal];

    XCTAssertEqualObjects(@1.54, number);
}

#pragma mark - testToBool

- (void)testTestToBoolTrue
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"true"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL boolValue = [self.sut testToBool];

    XCTAssertTrue(boolValue);
}

- (void)testTestToBoolOn
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"on"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL boolValue = [self.sut testToBool];

    XCTAssertTrue(boolValue);
}

- (void)testTestToBool1
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"1"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL boolValue = [self.sut testToBool];

    XCTAssertTrue(boolValue);
}

- (void)testTestToBoolFalse
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"false"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL boolValue = [self.sut testToBool];

    XCTAssertFalse(boolValue);
}

- (void)testTestToBoolString
{
    self.sut = [[RFChoiceCondition alloc] initWithTest:@"OMG"
                                              operator:'#'
                                            subPattern:@"subPattern"];

    BOOL boolValue = [self.sut testToBool];

    XCTAssertFalse(boolValue);
}

@end
