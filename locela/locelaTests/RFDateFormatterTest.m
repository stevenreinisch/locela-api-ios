//
//  RFDateFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 20/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFDateFormatter.h"

#pragma mark - private declarations

@interface RFDateFormatter (Testing)

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                dateFormat:(NSString *)dateFormat;

@end

#pragma mark -

@interface RFDateFormatterTest : XCTestCase

@property (nonatomic, strong) RFDateFormatter *sut;
@property (nonatomic, strong) NSDate          *date;

@end

#pragma mark -

@implementation RFDateFormatterTest

- (void)setUp
{
    [super setUp];

    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];
    self.sut         = [[RFDateFormatter alloc] initWithLocale:locale];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:10];
    [comps setYear:2010];
    self.date = [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)tearDown
{
    self.sut  = nil;
    self.date = nil;

    [super tearDown];
}

#pragma mark - tests

#pragma mark - replaceValue:inString:inRange:dateFormat

- (void)testReplaceValueInStringInRangeDateFormatNoDateFormat
{
    NSString *string = @"Heute ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Heute ist 01.10.2010", replaced);
}

- (void)testReplaceValueInStringInRangeDateFormatShortDateFormat
{
    NSString *string = @"Heute ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"short";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Heute ist 01.10.10", replaced);
}

@end
