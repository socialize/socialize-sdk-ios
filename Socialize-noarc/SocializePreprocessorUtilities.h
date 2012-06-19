//
//  SocializePreprocessorUtilities.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/29/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

// thanks http://borkware.com/quickies/one?topic=General
#define NSSTRING_FROM_SYMBOL2(x) @#x
#define NSSTRING_FROM_SYMBOL(x) NSSTRING_FROM_SYMBOL2(x)

#define SYNTH_CLASS_GETTER(CLASS, PROPERTY) \
@synthesize PROPERTY = PROPERTY ## _; \
- (Class)PROPERTY { \
if (PROPERTY ## _ == nil) { \
PROPERTY ## _ = NSClassFromString(NSSTRING_FROM_SYMBOL(CLASS)); \
} \
return PROPERTY ## _; \
}

