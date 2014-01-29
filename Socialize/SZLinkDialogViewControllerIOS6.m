//
//  SZLinkDialogViewControllerIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/6/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZLinkDialogViewControllerIOS6.h"
#import "SZNavigationControllerIOS6.h"

@implementation SZLinkDialogViewControllerIOS6

//navbar impl is set here, as this is a subclass of SZNavigationController
- (id)init {
    if (self = [super init]) {
        [SZNavigationControllerIOS6 initNavigationBar:self];
    }
    
    return self;
}

@end
