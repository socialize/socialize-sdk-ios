//
//  SZUserSettingsViewControllerIOS7.m
//  Socialize
//
//  Created by David Jedeikin on 1/6/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZUserSettingsViewControllerIOS7.h"
#import "SZNavigationControllerIOS7.h"

@implementation SZUserSettingsViewControllerIOS7

- (id)init {
    if (self = [super init]) {
        [SZNavigationControllerIOS7 initNavigationBar:self];
    }
    
    return self;
}

@end
