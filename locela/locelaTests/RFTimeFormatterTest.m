//
//  RFDateFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 20/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFTimeFormatter.h"

#pragma mark - private declarations

@interface RFTimeFormatter (Testing)

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                dateFormat:(NSString *)dateFormat;

@end

#pragma mark -

@interface RFTimeFormatterTest : XCTestCase

@property (nonatomic, strong) RFTimeFormatter *sut;
@property (nonatomic, strong) NSDate          *date;

@end

#pragma mark -

@implementation RFTimeFormatterTest

- (void)setUp
{
    [super setUp];

    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];
    self.sut         = [[RFTimeFormatter alloc] initWithLocale:locale];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:10];
    [comps setYear:2010];
    [comps setHour:9];
    [comps setMinute:15];
    [comps setSecond:02];
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

- (void)testReplaceValueInStringInRangeDateFormatTimeFormat
{
    NSString *string = @"Jetzt ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Jetzt ist 09:15:02", replaced);
}

- (void)testReplaceValueInStringInRangeDateFormatShortTimeFormat
{
    NSString *string = @"Jetzt ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"short";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Jetzt ist 09:15", replaced);
}

- (void)testReplaceValueInStringInRangeDateFormatMediumTimeFormat
{
    NSString *string = @"Jetzt ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"medium";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Jetzt ist 09:15:02", replaced);
}

- (void)testReplaceValueInStringInRangeDateFormatLongTimeFormat
{
    NSString *string = @"Jetzt ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"long";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Jetzt ist 09:15:02 MESZ", replaced);
}

- (void)testReplaceValueInStringInRangeDateFormatFullTimeFormat
{
    NSString *string = @"Jetzt ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"full";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Jetzt ist 09:15 Uhr MESZ", replaced);
}

- (void)testReplaceValueInStringInRangeDateFormatCustomTimeFormat
{
    NSString *string = @"Jetzt ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"HH:mm:ss";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                     dateFormat:format];

    XCTAssertEqualObjects(@"Jetzt ist 09:15:02", replaced);
}

@end