//
//  SZShareOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareOptions.h"
#import "SZShareUtils.h"

@implementation SZShareOptions

@synthesize text = text_;
@synthesize willShowSMSComposerBlock = _willShowSMSComposerBlock;
@synthesize willShowEmailComposerBlock = _willShowEmailComposerBlock;

+ (SZShareOptions *)defaultOptions {
    SZShareOptions *options = [[self alloc] init];
    return options;
}

@end