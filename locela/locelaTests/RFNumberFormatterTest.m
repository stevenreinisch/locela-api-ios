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
- (NSString *)formatFromPlaceholder:(NSString *)placeholder;
- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                    format:(NSString *)format;

@end

#pragma mark -

@interface RFNumberFormatterTest : XCTestCase

@property (nonatomic, strong)RFNumberFormatter *sut;

@end

#pragma mark -

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
    NSString *placeholder = @"{12, number, 0.00E0 }";

    NSString *format = [self.sut formatFromPlaceholder:placeholder];

    XCTAssertEqualObjects(@"0.00E0", format);
}

#pragma mark - replaceValue:inString:inRange:numberFormat

- (void)testReplaceValueInStringInRangeNumberFormat
{
    NSString *string = @"Amount: X";
    NSNumber *value  = @(1235);
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"0.00E0";
    
    NSString *replaced = [self.sut replaceValue:value
                                       inString:string
                                        inRange:range
                                         format:format];
    
    XCTAssertEqualObjects(@"Amount: 1.24E3", replaced);
}

@end
