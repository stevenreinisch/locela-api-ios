//
//  RFChoiceFormatterTest.m
//  locela
//
//  Created by steffen on 25/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFChoiceFormatter.h"
#import "RFChoiceCondition.h"

#pragma mark - private declarations

@interface RFChoiceFormatter (Testing)

- (NSArray *)conditionsFromString:(NSString *)string;
- (RFChoiceCondition *)extractConditionFromString:(NSString **)string;
- (NSString *)evaluateConditions:(NSString *)conditionsString
                           value:(id)value;

@end

#pragma mark -

@interface RFChoiceFormatterTest : XCTestCase

@property (nonatomic, strong)RFChoiceFormatter *sut;

@end

#pragma mark -

@implementation RFChoiceFormatterTest

- (void)setUp
{
    [super setUp];
    
    self.sut = [[RFChoiceFormatter alloc] init];
}

- (void)tearDown
{
    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - tests

#pragma mark - conditionsFromString

- (void)testConditionsFromStringNil
{
    NSArray *conditions = [self.sut conditionsFromString:nil];
    XCTAssertNotNil(conditions);
    XCTAssertEqual(0, conditions.count);
}

- (void)testConditionsFromStringEmpty
{
    NSArray *conditions = [self.sut conditionsFromString:@""];
    XCTAssertNotNil(conditions);
    XCTAssertEqual(0, conditions.count);
}

- (void)testConditionsFromStringThreeConditions
{
    NSString *string = @"0#is no file|1#is one file|1<are {zero,number} files";

    NSArray *conditions = [self.sut conditionsFromString:string];
    XCTAssertNotNil(conditions);
    XCTAssertEqual(3, conditions.count);
}

#pragma mark - extractConditionFromString:

- (void)testExtractConditionFromString
{
    NSString *string = @"0#is no file|1#is one file|1<are {zero,number} files";

    RFChoiceCondition *condition = [self.sut extractConditionFromString:&string];

    XCTAssertEqualObjects(string, @"1#is one file|1<are {zero,number} files");
    XCTAssertNotNil(condition);
    XCTAssertEqual('#', condition.operator);
    XCTAssertEqualObjects(@"0", condition.test);
    XCTAssertEqualObjects(@"is no file", condition.subPattern);
}

- (void)testExtractConditionFromStringOneCondition
{
    NSString *string = @"1<are {zero,number} files";
    NSString *withoutCondition = nil;

    RFChoiceCondition *condition = [self.sut extractConditionFromString:&string];

    XCTAssertEqualObjects(string, @"");
    XCTAssertNotNil(condition);
    XCTAssertEqual('<', condition.operator);
    XCTAssertEqualObjects(@"1", condition.test);
    XCTAssertEqualObjects(@"are {zero,number} files", condition.subPattern);
}

#pragma mark - evaluateConditions:value:

- (void)testEvaluateConditions1
{
    NSString *format = @"0#is no file|1#is one file|1<are {0,number} files";

    NSString *result = [self.sut evaluateConditions:format
                                              value:@0];

    XCTAssertEqualObjects(@"is no file", result);
}

- (void)testEvaluateConditions2
{
    NSString *format = @"0#is no file|1#is one file|1<are {0,number} files";

    NSString *result = [self.sut evaluateConditions:format
                                              value:@1];

    XCTAssertEqualObjects(@"is one file", result);
}

- (void)testEvaluateConditions3
{
    NSString *format = @"0#is no file|1#is one file|1<are {0,number} files";

    NSString *result = [self.sut evaluateConditions:format
                                              value:@10];

    XCTAssertEqualObjects(@"are {0,number} files", result);
}

@end
