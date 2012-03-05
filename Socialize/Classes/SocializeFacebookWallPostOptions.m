//
//  SocializeFacebookWallPosterOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookWallPostOptions.h"

@implementation SocializeFacebookWallPostOptions
@synthesize facebookAuthOptions = facebookAuthOptions;
@synthesize message = message_;
@synthesize link = link_;
@synthesize caption = caption_;
@synthesize name = name_;

- (void)dealloc {
    self.facebookAuthOptions = nil;
    self.message = nil;
    self.link = nil;
    self.caption = nil;
    self.name = nil;
    
    [super dealloc];
}

@end
