//
//  SZShareOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareOptions.h"

@implementation SZShareOptions
@synthesize text = text_;
@synthesize willShowSMSComposerBlock = _willShowSMSComposerBlock;
@synthesize willShowEmailComposerBlock = _willShowEmailComposerBlock;

+ (SZShareOptions*)defaultOptions {
    return [[self alloc] init];
}

@end