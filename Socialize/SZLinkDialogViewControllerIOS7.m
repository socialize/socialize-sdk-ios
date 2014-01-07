//
//  SZLinkDialogViewControllerIOS7.m
//  Socialize
//
//  Created by David Jedeikin on 1/6/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZLinkDialogViewControllerIOS7.h"
#import "SZNavigationControllerIOS7.h"

@implementation SZLinkDialogViewControllerIOS7

//navbar impl is set here, as link dialog is a subclass of SZNavigationController
- (id)init {
    if (self = [super init]) {
        [SZNavigationControllerIOS7 initNavigationBar:self];
    }
    
    return self;
}

@end
