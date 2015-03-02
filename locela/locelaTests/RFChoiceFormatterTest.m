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
- (RFChoiceCondition *)extractConditionFromString:(NSString *)string
                           stringWithoutCondition:(NSString **)withoutCondition;

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

- (void)testExample1
{
    //NSString *string = @"There {zero,choice,0#is no file|1#is one file|1<are {zero,number} files}.";
    NSString *string = @"There {0,choice,0#is no file|1#is one file|1<are {0,number} files}.";
    
    /*
        - parse conditions
        - evaluate conditions
            - first one that evaluates to true is used to replace the placeholder with its subpattern
     
    
        condition: <test><operator><subPattern>
        
        class Condition
        {
            String test
            char   op
            String subPattern
            
            BOOL eval(value)
            {
                switch (op)
                {
                    case EQUALS      : {
                        
                        if (value is number) return test == value
                        if (value is BOOL)   return test == value
                        if (value is String) return [test isEqualToString:value]
     
                    } break;
     
                    case GREATER_THAN: return test < value
                }
            }
        }
     
        ChoiceFormatter -*-> Condition
     */
    
    NSString *result = nil;
    
    NSString *expected = @"There is no file.";
    
    XCTAssertEqualObjects(result, expected);
}

- (void)testExample2
{
    NSString *string = @"There {one,choice,0#is no file|1#is one file|1<are {one,number} files}.";
    
    /*
       conditions:
       0 == one => @"is no file"
       1 == one => @"is one file"
       1 <  one => @"are {one, number} files"
     
     */
    
    NSString *result = nil;
    
    NSString *expected = @"There is one file.";
    
    XCTAssertEqualObjects(result, expected);
}

- (void)testExample3
{
    NSString *string = @"This is {aTrue,choice,true#TRUE|false#FALSE}.";
    
    NSString *result = nil;
    
    NSString *expected = @"This is TRUE.";
    
    XCTAssertEqualObjects(result, expected);
}

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

#pragma mark - extractConditionFromString:stringWithoutCondition:

- (void)testExtractConditionFromString
{
    NSString *string = @"0#is no file|1#is one file|1<are {zero,number} files";
    NSString *withoutCondition = nil;

    RFChoiceCondition *condition = [self.sut extractConditionFromString:string
                                                 stringWithoutCondition:&withoutCondition];

    XCTAssertEqualObjects(withoutCondition, @"1#is one file|1<are {zero,number} files");
    XCTAssertNotNil(condition);
    XCTAssertEqual('#', condition.operator);
    XCTAssertEqualObjects(@"0", condition.test);
    XCTAssertEqualObjects(@"is no file", condition.subPattern);
}

- (void)testExtractConditionFromStringOneCondition
{
    NSString *string = @"1<are {zero,number} files";
    NSString *withoutCondition = nil;

    RFChoiceCondition *condition = [self.sut extractConditionFromString:string
                                                 stringWithoutCondition:&withoutCondition];

    XCTAssertEqualObjects(withoutCondition, @"");
    XCTAssertNotNil(condition);
    XCTAssertEqual('<', condition.operator);
    XCTAssertEqualObjects(@"1", condition.test);
    XCTAssertEqualObjects(@"are {zero,number} files", condition.subPattern);
}

@end
