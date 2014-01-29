//
//  SZLinkDialogViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZLinkDialogViewController.h"
#import "_SZLinkDialogViewController.h"
#import "SZLinkDialogViewControllerIOS6.h"
#import "UIDevice+VersionCheck.h"

@interface SZLinkDialogViewController ()
@property (nonatomic, strong) _SZLinkDialogViewController *linkDialog;

@end

@implementation SZLinkDialogViewController
@synthesize linkDialog = _linkDialog;
@dynamic completionBlock;
@dynamic cancellationBlock;

//class cluster impl
//used for navbar as this class is a subclass of SZNavigationBar
+ (id)alloc {
    if([self class] == [SZLinkDialogViewController class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [SZLinkDialogViewControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

- (id)init {
    if (self = [super init]) {
        self.linkDialog = [[_SZLinkDialogViewController alloc] initWithDelegate:nil];
        [self pushViewController:self.linkDialog animated:NO];
    }
    
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.linkDialog;
}

@end
