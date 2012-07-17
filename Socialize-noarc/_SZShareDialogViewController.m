//
//  _SZShareDialogViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "_SZShareDialogViewController.h"
#import "SZShareUtils.h"
#import "socialize_globals.h"

@interface _SZShareDialogViewController ()

@end

@implementation _SZShareDialogViewController
@synthesize completionBlock = _completionBlock;
@synthesize cancellationBlock = _cancellationBlock;

- (id)initWithEntity:(id<SocializeEntity>)entity {
    if (self = [super initWithEntity:entity]) {
        self.disableAutopostSelection = YES;
        self.showOtherShareTypes = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block __typeof__(self) weakSelf = self;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem redSocializeBarButtonWithTitle:@"Cancel" handler:^(id sender) {
        BLOCK_CALL(weakSelf.cancellationBlock);
    }];
}

- (void)continueButtonPressed:(id)sender {
    SZSocialNetwork networks = [self selectedNetworks];
    
    if (networks == SZSocialNetworkNone) {
        [UIAlertView showAlertWithTitle:@"Select a Network" message:@"One or more networks must be selected to perform a share" buttonTitle:@"Ok" handler:nil];
    } else {
        
        SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
        [self startLoading];
        [SZShareUtils shareViaSocialNetworksWithEntity:self.entity networks:networks options:shareOptions success:^(id<SZShare> share) {
            [self stopLoading];
            [self.createdShares addObject:share];
            BLOCK_CALL_1(self.completionBlock, self.createdShares);
        } failure:^(NSError *error) {
            [self stopLoading];
            [self failWithError:error];
        }];
    }
}

@end
