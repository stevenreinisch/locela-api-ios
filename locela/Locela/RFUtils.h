//
//  RFUtils.h
//  Locela
//
//  Created by steven reinisch on 27/03/15.
//  Copyright (c) 2015 teufel lautsprecher. All rights reserved.
//

#define RF_ABSTRACT_METHOD(ret) \
{\
[self doesNotRecognizeSelector:_cmd]; \
__builtin_unreachable(); \
return ret;\
}