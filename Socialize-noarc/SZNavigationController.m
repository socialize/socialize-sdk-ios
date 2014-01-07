//
//  SZNavigationController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UIDevice+VersionCheck.h"
#import "SZNavigationController.h"
#import "SZNavigationControllerIOS6.h"

@interface SZNavigationController ()

@end

@implementation SZNavigationController

+ (id)alloc {
    if([self class] == [SZNavigationController class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [SZNavigationControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

@end
