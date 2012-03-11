//
//  SocializeLikeCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeCreator.h"

@implementation SocializeLikeCreator

- (id<SocializeLike>)like {
    return (id<SocializeLike>)self.activity;
}

@end
