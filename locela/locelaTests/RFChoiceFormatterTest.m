//
//  RFChoiceFormatterTest.m
//  locela
//
//  Created by steffen on 25/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFChoiceFormatter.h"

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
    NSString *string = @"There {0,choice,0#is no file|1#is one file|1<are {zero,number} files}.";
    
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

@end
