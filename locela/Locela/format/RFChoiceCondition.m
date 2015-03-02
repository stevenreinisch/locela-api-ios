//
// Created by steven reinisch on 27/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import "RFChoiceCondition.h"

typedef BOOL (^operatorEval)(id test);

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
                result = [self evaluateValue:value op:^BOOL(id test)
                {
                    return [(NSDecimalNumber *) value isEqualToNumber:test];
                }];
            }
            else if ([value isKindOfClass:[NSNumber class]])
            {
                result = [self evaluateValue:value op:^BOOL(id test)
                {
                    return [(NSNumber *) value isEqualToNumber:test];
                }];
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                result = [self evaluateValue:value op:^BOOL(id test)
                {
                    return [(NSString *) value isEqualToString:test];
                }];
            }
            else if ([value isKindOfClass:[NSValue class]])//this indicates a BOOL in our implementation
            {
                result = [self evaluateValue:value op:^BOOL(id test)
                {
                    BOOL boolValue = NO;
                    [(NSValue *)value getValue:&boolValue];

                    return boolValue == [self testToBool];
                }];
            }
        } break;

        case '<':
        {
            if ([value isKindOfClass:[NSDecimalNumber class]])
            {
                result = [self evaluateValue:value op:^BOOL(id test)
                {
                    return [(NSDecimalNumber *) value compare:test] == NSOrderedDescending;
                }];
            }
            else if ([value isKindOfClass:[NSNumber class]])
            {
                result = [self evaluateValue:value op:^BOOL(id test)
                {
                    return [(NSNumber *) value compare:test] == NSOrderedDescending;
                }];
            }
        } break;
    }

    return result;
}

#pragma mark - private

- (BOOL)evaluateValue:(id<NSObject>)value
                   op:(operatorEval)operatorEval
{
    BOOL result = NO;

    if ([value isKindOfClass:[NSDecimalNumber class]])
    {
        NSDecimalNumber *decimal = [self testToDecimal];

        if (decimal)
        {
            result = operatorEval(decimal);
        }
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        NSNumber *num = [self testToNumber];

        if (num)
        {
            result = operatorEval(num);
        }
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        if (self.test)
        {
            result = operatorEval(self.test);
        }
    }
    else if ([value isKindOfClass:[NSValue class]])//this indicates a BOOL in our implementation
    {
        result = operatorEval(value);
    }

    return result;
}

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