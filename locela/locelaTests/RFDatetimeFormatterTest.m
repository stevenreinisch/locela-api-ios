//
//  RFDatetimeFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 23/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFDatetimeFormatter.h"

#pragma mark - private declarations

@interface RFDatetimeFormatter (Testing)

- (NSString *)replaceValue:(id)value
                  inString:(NSString *)string
                   inRange:(NSRange)range
                    format:(NSString *)dateFormat;

@end

#pragma mark -

@interface RFDatetimeFormatterTest : XCTestCase

@property (nonatomic, strong)RFDatetimeFormatter *sut;
@property (nonatomic, strong)NSDate              *date;

@end

#pragma mark -

@implementation RFDatetimeFormatterTest

- (void)setUp
{
    [super setUp];

    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];
    self.sut         = [[RFDatetimeFormatter alloc] initWithLocale:locale];

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

- (void)testReplaceValueInStringInRangeDateFormatDatetimeFormat
{
    NSString *string = @"Jetzt ist X";
    NSRange  range   = NSMakeRange(string.length - 1, 1);
    NSString *format = @"";

    NSString *replaced = [self.sut replaceValue:self.date
                                       inString:string
                                        inRange:range
                                         format:format];

    XCTAssertEqualObjects(@"Jetzt ist 01.10.2010 09:15:02", replaced);
}



@end
