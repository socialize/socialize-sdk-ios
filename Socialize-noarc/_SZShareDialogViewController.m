//
//  _SZShareDialogViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "_SZShareDialogViewController.h"
#import "SZShareUtils.h"

@interface _SZShareDialogViewController ()

@end

@implementation _SZShareDialogViewController
@synthesize completionBlock = _completionBlock;

- (id)initWithEntity:(id<SocializeEntity>)entity {
    if (self = [super initWithEntity:entity]) {
        self.disableAutopostSelection = YES;
        self.showOtherShareTypes = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem redSocializeBarButtonWithTitle:@"Cancel" handler:^(id sender) {
        BLOCK_CALL_1(self.completionBlock, [NSArray array]);
    }];
}

- (void)continueButtonPressed:(id)sender {
    SZSocialNetwork networks = [self selectedNetworks];
    SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
    [self startLoading];
    [SZShareUtils shareViaSocialNetworksWithEntity:self.entity networks:networks options:shareOptions success:^(id<SZShare> share) {
        [self.createdShares addObject:share];
        BLOCK_CALL_1(self.completionBlock, self.createdShares);
    } failure:^(NSError *error) {
        [self stopLoading];
        [self failWithError:error];
    }];
    [self stopLoading];
}

@end
