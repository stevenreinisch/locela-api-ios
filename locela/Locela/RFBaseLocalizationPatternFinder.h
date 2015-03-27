//
// Created by steven reinisch on 27/03/15.
// Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFLocalizationPatternFinder.h"


@interface RFBaseLocalizationPatternFinder : NSObject <RFLocalizationPatternFinder>

@property (nonatomic, strong) RFLocalizationPatternProvider *patternProvider;

@end