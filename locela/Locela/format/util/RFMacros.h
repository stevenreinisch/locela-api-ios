//
//  RFMacros.h
//  Locela
//
//  Created by steven reinisch on 06/03/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#define ABSTRACT_METHOD {\
 [self doesNotRecognizeSelector:_cmd]; \
 __builtin_unreachable(); \
}
