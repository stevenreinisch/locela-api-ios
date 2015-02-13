//
//  RFMessageFormatterTest.m
//  Locela
//
//  Created by steven reinisch on 13/02/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RFMessageFormatter.h"

#pragma mark - private formward declarations

@interface RFMessageFormatter (Testing)

@property (nonatomic, strong) NSLocale *locale;

@end

#pragma mark -

@interface RFMessageFormatterTest : XCTestCase

@property (nonatomic, strong) RFMessageFormatter *sut;

@end

#pragma mark - tests

@implementation RFMessageFormatterTest

- (void)setUp {
    [super setUp];

    NSLocale *currentLocale = [NSLocale currentLocale];
    self.sut = [[RFMessageFormatter alloc] initWithLocale:currentLocale];
}

- (void)tearDown {

    [super tearDown];
}

#pragma mark - tests

#pragma mark - initWithLocale:

- (void)testInitWithLocaleNil {

    self.sut = [[RFMessageFormatter alloc] initWithLocale:nil];

    XCTAssertEqualObjects([NSLocale currentLocale], self.sut.locale, @"locale must be default locale if none is given");
}

@end
