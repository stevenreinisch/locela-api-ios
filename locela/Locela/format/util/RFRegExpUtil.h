//
// Created by steven reinisch on 02/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RFRegExpUtil : NSObject

+ (BOOL) matchString:(NSString *)string
againstRegExpPattern:(NSString *)regExPattern
               match:(NSTextCheckingResult **)match
               error:(NSError **)error;

@end