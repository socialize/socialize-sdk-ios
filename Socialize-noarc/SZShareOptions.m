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

@synthesize loopyEnabled;
@synthesize text = text_;
@synthesize willShowSMSComposerBlock = _willShowSMSComposerBlock;
@synthesize willShowEmailComposerBlock = _willShowEmailComposerBlock;

//init Loopy by default
- (id)init {
    if(self == [super init]) {
        self.loopyEnabled = YES;
        [SZShareUtils sharedLoopyAPIClient]; //init this up-front
    }
    
    return self;
}

+ (SZShareOptions *)defaultOptions {
    SZShareOptions *options = [[self alloc] init];
    return options;
}

@end