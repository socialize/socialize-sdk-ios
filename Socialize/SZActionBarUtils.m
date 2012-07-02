//
//  SZActionBarUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZActionBarUtils.h"
#import "SocializeObjects.h"
#import "SZActionBar.h"

@implementation SZActionBarUtils

+ (SZActionBar*)showActionBarWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity options:(id)options {
    SZActionBar *actionBar = [SZActionBar defaultActionBarWithFrame:CGRectNull entity:entity viewController:viewController];
    [viewController.view addSubview:actionBar];
    
    return actionBar;
}

@end
