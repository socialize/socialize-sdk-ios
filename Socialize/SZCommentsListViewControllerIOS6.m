//
//  SZCommentsListViewControllerIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/7/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZCommentsListViewControllerIOS6.h"
#import "SZNavigationControllerIOS6.h"

@implementation SZCommentsListViewControllerIOS6

//navbar impl is set here, as this is a subclass of SZNavigationController
- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super initWithEntity:entity]) {
        [SZNavigationControllerIOS6 initNavigationBar:self];
    }
    
    return self;
}

@end
