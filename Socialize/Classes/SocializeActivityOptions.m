//
//  SocializeActivityOptions.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityOptions.h"

@implementation SocializeActivityOptions
@synthesize thirdParties = thirdParties_;

- (void)dealloc {
    self.thirdParties = nil;
    
    [super dealloc];
}

@end
