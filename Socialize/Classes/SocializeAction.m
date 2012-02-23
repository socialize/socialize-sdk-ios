//
//  SocializeAction.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeUIDisplay.h"
#import "_Socialize.h"

@implementation SocializeAction
@synthesize socialize = socialize_;
@synthesize display = display_;

- (void)dealloc {
    [socialize_ setDelegate:nil];
    self.socialize = nil;
    self.display = nil;
    
    [super dealloc];
}

- (id)initWithDisplayHandler:(id)displayHandler {
    if (self = [super init]) {
        self.display = [SocializeUIDisplay UIDisplayWithDisplayHandler:displayHandler];
    }
    return self;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    return socialize_;
}

- (void)cancelAllCallbacks {
    [socialize_ setDelegate:nil];
}

@end
