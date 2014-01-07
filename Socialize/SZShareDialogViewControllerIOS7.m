//
//  SZShareDialogViewControllerIOS7.m
//  Socialize
//
//  Created by David Jedeikin on 1/6/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZShareDialogViewControllerIOS7.h"
#import "SZNavigationControllerIOS7.h"

@implementation SZShareDialogViewControllerIOS7

//navbar impl is set here, as share dialog is a subclass of SZNavigationController
- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super initWithEntity:entity]) {
        [SZNavigationControllerIOS7 initNavigationBar:self];
    }
    
    return self;
}

@end
