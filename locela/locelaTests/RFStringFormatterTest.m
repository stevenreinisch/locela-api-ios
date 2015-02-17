//
//  RFStringFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 17/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFStringFormatter.h"

#pragma mark - private formward declarations

@interface RFStringFormatter (Testing)

//@property (nonatomic, strong) NSLocale *locale;

- (NSInteger)indexFromPlaceholder:(NSString *)placeholder;
- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range;

@end

#pragma mark -

@interface RFStringFormatterTest : XCTestCase

@property (nonatomic, strong) RFStringFormatter *sut;

@end

#pragma mark -

@implementation RFStringFormatterTest

- (void)setUp
{
    [super setUp];

    self.sut = [[RFStringFormatter alloc] init];
}

- (void)tearDown
{
    self.sut = nil;

    [super tearDown];
}

#pragma mark - tests

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
