//
//  RFNumberFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 17/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFNumberFormatter.h"

#pragma mark - private forward declarations

@interface RFNumberFormatter (Testing)

- (NSInteger)indexFromPlaceholder:(NSString *)placeholder;
- (NSString *)numberFormatFromPlaceholder:(NSString *)placeholder;

@end

#pragma mark -

@interface RFNumberFormatterTest : XCTestCase

@property (nonatomic, strong)RFNumberFormatter *sut;

@end

@implementation RFNumberFormatterTest

- (void)setUp
{
    [super setUp];

    self.sut = [[RFNumberFormatter alloc] init];
}

- (void)tearDown
{
    self.sut = nil;

    [super tearDown];
}

#pragma mark - tests

#pragma mark - indexFromPlaceholder

- (void)testIndexFromPlaceholder
{
    NSString *placeholder = @"{12,number,0E0}";

    NSUInteger index = [self.sut indexFromPlaceholder:placeholder];

    XCTAssertEqual(12, index);
}

#pragma mark - numberFormatFromPlaceholder

- (void)testNumberFormatFromPlaceholder
{
    NSString *placeholder = @"{12, number, 0.00E0}";

    NSString *format = [self.sut numberFormatFromPlaceholder:placeholder];

    XCTAssertEqualObjects(@"0.00E0", format);
}

@end
