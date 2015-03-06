//
//  RFMessageFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 13/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFMessageFormatter.h"
#import "RFStringFormatter.h"
#import "RFNumberFormatter.h"
#import "RFDateFormatter.h"
#import "RFTimeFormatter.h"
#import "RFDatetimeFormatter.h"
#import "RFChoiceFormatter.h"

extern NSString *const kRFMessageFormatterSimplePlaceholderPattern;
extern NSString *const kRFMessageFormatterNumberPlaceholderPattern;
extern NSString *const kRFMessageFormatterDatePlaceholderPattern;
extern NSString *const kRFMessageFormatterTimePlaceholderPattern;
extern NSString *const kRFMessageFormatterDatetimePlaceholderPattern;
extern NSString *const kRFMessageFormatterChoicePlaceholderPattern;
extern NSString *const kRFMessageFormatterChoicePlaceholderPattern;

#pragma mark - private forward declarations

@interface RFMessageFormatter (Testing)

@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, strong) NSDictionary *formatterClasses;

@end

#pragma mark -

@interface RFMessageFormatterTest : XCTestCase

@property (nonatomic, strong) RFMessageFormatter *sut;

@end

#pragma mark - tests

@implementation RFMessageFormatterTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{

    [super tearDown];
}

#pragma mark - tests

#pragma mark - initWithLocale:

- (void)testInitWithLocaleNil
{

    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:nil];

    XCTAssertEqualObjects([NSLocale currentLocale], self.sut.locale, @"locale must be default locale if none is given");
    XCTAssertNotNil(self.sut.formatterClasses);
}

- (void)testInitWithLocaleNotNil {

    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];

    self.sut = [[RFMessageFormatter alloc] initWithLocale:locale
                                                  pattern:nil];

    XCTAssertEqualObjects(locale, self.sut.locale, @"locale must match given locale");
    XCTAssertNotNil(self.sut.formatterClasses);
}

#pragma mark - formatterClasses

- (void)testFormatterClassesAreCreated
{
    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:nil];

    XCTAssertNotNil(self.sut.formatterClasses);

    Class stringFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterSimplePlaceholderPattern];
    XCTAssertEqualObjects([RFStringFormatter class], stringFormatterClass);

    Class numberFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterNumberPlaceholderPattern];
    XCTAssertEqualObjects([RFNumberFormatter class], numberFormatterClass);

    Class dateFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterDatePlaceholderPattern];
    XCTAssertEqualObjects([RFDateFormatter class], dateFormatterClass);

    Class timeFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterTimePlaceholderPattern];
    XCTAssertEqualObjects([RFTimeFormatter class], timeFormatterClass);

    Class dateTimeFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterDatetimePlaceholderPattern];
    XCTAssertEqualObjects([RFDatetimeFormatter class], dateTimeFormatterClass);

    Class choiceFormatterClass = [self.sut.formatterClasses objectForKey:kRFMessageFormatterChoicePlaceholderPattern];
    XCTAssertEqualObjects([RFChoiceFormatter class], choiceFormatterClass);
}

#pragma mark - formatPattern:values

- (void)testFormatPatternValuesOneNumber
{
    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:@"Hello {0, number}!"];

    NSString *result = [self.sut format:@[@21]];

    XCTAssertEqualObjects(@"Hello 21!", result);
}

- (void)testFormatPatternValuesOneString
{
    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:@"Hello {0}!"];

    NSString *result = [self.sut format:@[@"Klaus"]];
    
    XCTAssertEqualObjects(@"Hello Klaus!", result);
}

- (void)testFormatPatternValuesTwoStringsInOrder
{
    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:@"Hello {0} you are {1}!"];

    NSString *result = [self.sut format:@[@"Klaus", @"awesome"]];

    XCTAssertEqualObjects(@"Hello Klaus you are awesome!", result);
}

- (void)testFormatPatternValuesTwoStringsNotInOrder
{
    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:@"Hello {1} you are {0}!"];

    NSString *result = [self.sut format:@[@"Klaus", @"awesome"]];

    XCTAssertEqualObjects(@"Hello awesome you are Klaus!", result);
}

- (void)testFormatPatternValuesWithCurrency
{
    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:@"Please Pay {0,number,¤0.00}!"];

    NSString *result = [self.sut format:@[@(1.5)]];

    XCTAssertEqualObjects(@"Please Pay $1.50!", result);
}

- (void)testFormatPatternValuesWithCurrencyAndString
{
    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil
                                                  pattern:@"{0} please pay {1,number,¤0.00}!"];

    NSString *result = [self.sut format:@[@"Dieter", @(1.5)]];

    XCTAssertEqualObjects(@"Dieter please pay $1.50!", result);
}

- (void)testFormatPatternValuesWithDate
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:10];
    [comps setYear:2010];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];

    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];

    self.sut = [[RFMessageFormatter alloc] initWithLocale:locale
                                                  pattern:@"Heute ist {0,date}."];

    NSString *result = [self.sut format:@[date]];

    XCTAssertEqualObjects(@"Heute ist 01.10.2010.", result);
}

- (void)testFormatPatternValuesWithChoice
{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_EN"];

    NSString *pattern = @"There {0,choice,0#is no file|1#is one file|1<are {0,number} files}.";

    self.sut = [[RFMessageFormatter alloc] initWithLocale:locale
                                                  pattern:pattern];

    NSString *result = [self.sut format:@[@0]];

    XCTAssertEqualObjects(@"There is no file.", result);
}

- (void)testFormatPatternValuesWithChoiceAndSubPattern
{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_EN"];

    NSString *pattern = @"There {0,choice,0#is no file|1#is one file|1<are {0,number} files}.";

    self.sut = [[RFMessageFormatter alloc] initWithLocale:locale
                                                  pattern:pattern];

    NSString *result = [self.sut format:@[@10]];

    XCTAssertEqualObjects(@"There are 10 files.", result);
}

- (void)testFormatPatternValuesWithDateAndChoice
{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];

    NSString *pattern = @"Heute ist {0,date} und die Katze hat {1,choice,1#einen Schwanz|1<{1,number} Schwänze.}";

    self.sut = [[RFMessageFormatter alloc] initWithLocale:locale
                                                  pattern:pattern];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:10];
    [comps setYear:2010];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];

    NSString *result = [self.sut format:@[date, @4]];

    XCTAssertEqualObjects(@"Heute ist 01.10.2010 und die Katze hat 4 Schwänze.", result);
}

@end
