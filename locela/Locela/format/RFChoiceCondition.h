//
// Created by steven reinisch on 27/02/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RFChoiceCondition : NSObject

@property (nonatomic, readonly, copy) NSString *test;
@property (nonatomic, readonly, assign) char operator;
@property (nonatomic, readonly, copy) NSString *subPattern;

- (instancetype)initWithTest:(NSString *)test
                    operator:(char)operator
                  subPattern:(NSString *)subPattern NS_DESIGNATED_INITIALIZER;

- (BOOL)evaluate:(id<NSObject>)value;

@end