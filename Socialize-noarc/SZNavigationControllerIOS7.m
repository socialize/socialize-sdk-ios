//
//  SZViewControllerIOS7.m
//  Socialize
//
//  Created by David Jedeikin on 1/5/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZNavigationControllerIOS7.h"

@implementation SZNavigationControllerIOS7

- (id)init {
    if (self = [super init]) {
        [SZNavigationControllerIOS7 initNavigationBar:self];
    }
    
    return self;
}

+ (void)initNavigationBar:(UINavigationController *)controller {
    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor blackColor], NSForegroundColorAttributeName,
                                               nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
}
@end
