//
// Created by steven reinisch on 27/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFChoiceCondition.h"

#pragma mark - private

@interface RFChoiceCondition ()

@property (nonatomic, copy) NSString *test;
@property (nonatomic, assign) char operator;
@property (nonatomic, copy) NSString *subPattern;

@end

#pragma mark -

@implementation RFChoiceCondition

- (instancetype)initWithTest:(NSString *)test
                    operator:(char)operator
                  subPattern:(NSString *)subPattern
{
    self = [super init];

    if (self)
    {
        _test       = test;
        _operator   = operator;
        _subPattern = subPattern;
    }

    return self;
}

- (BOOL)evaluate:(id<NSObject>)value
{
    BOOL result = NO;

    switch (self.operator)
    {
        case '#':
        {
            if ([value isKindOfClass:[NSDecimalNumber class]])
            {
                NSDecimalNumber *decimal = [self testToDecimal];

                if (decimal)
                {
                    result = [(NSDecimalNumber *) value isEqualToNumber:decimal];
                }
            }
            else if ([value isKindOfClass:[NSNumber class]])
            {
                NSNumber *num = [self testToNumber];

                if (num)
                {
                    result = [(NSNumber *) value isEqualToNumber:num];
                }
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                if (self.test)
                {
                    result = [(NSString *) value isEqualToString:self.test];
                }
            }
            else if ([value isKindOfClass:[NSValue class]])//this indicates a BOOL in our implementation
            {
                BOOL boolValue = NO;
                [(NSValue *)value getValue:&boolValue];

                result = boolValue == [self testToBool];
            }
        } break;

        case '<':
        {
            //TODO
        } break;
    }

    return result;
}

#pragma mark - private

- (NSNumber *)testToNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    return [formatter numberFromString:self.test];
}

- (NSDecimalNumber *)testToDecimal
{
    return [NSDecimalNumber decimalNumberWithString:self.test];
}

- (BOOL)testToBool
{
    BOOL result = NO;

    if ([@"true" caseInsensitiveCompare:self.test] == NSOrderedSame)
    {
        result = YES;
    }
    else if ([@"on" caseInsensitiveCompare:self.test] == NSOrderedSame)
    {
        result = YES;
    }
    else if ([@"1" caseInsensitiveCompare:self.test] == NSOrderedSame)
    {
        result = YES;
    }

    return result;
}

@end