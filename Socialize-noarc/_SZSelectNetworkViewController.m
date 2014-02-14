//
//  _SZSelectNetworkViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "_SZSelectNetworkViewController.h"
#import "socialize_globals.h"
#import <SZBlocksKit/BlocksKit+UIKit.h>

@interface _SZSelectNetworkViewController ()

@end

@implementation _SZSelectNetworkViewController
@synthesize completionBlock = _completionBlock;

- (void)dealloc {
    self.completionBlock = nil;
    
    [super dealloc];
}

- (id)initWithEntity:(id<SocializeEntity>)entity {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)init {
    if (self = [super initWithNibName:@"SZBaseShareViewController" bundle:nil]) {
        self.dontRequireNetworkSelection = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.title length] == 0) {
        self.title = @"Share";
    }

}

- (void)continueButtonPressed:(id)sender {
    SZSocialNetwork networks = [self selectedNetworks];
    if (networks == SZSocialNetworkNone && !self.dontRequireNetworkSelection) {
        [UIAlertView bk_showAlertViewWithTitle:@"No Networks Selected"
                                       message:@"Please select one or more networks to continue."
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil handler:nil];
        return;
    }
    [self persistSelection];
    
    BLOCK_CALL_1(self.completionBlock, networks);
}

@end
