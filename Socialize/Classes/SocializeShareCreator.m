//
//  SocializeShareCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeShareCreator.h"

@implementation SocializeShareCreator

- (id<SocializeShare>)share {
    return (id<SocializeShare>)self.activity;
}

@end
