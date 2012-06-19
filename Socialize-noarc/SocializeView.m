//
//  SocializeView.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeView.h"


@implementation SocializeView

+ (SocializeView*)viewWithEntity:(id<SocializeEntity>)entity {
    SocializeView *view = [[[self alloc] init] autorelease];
    view.entity = entity;
    return view;
}

@end
