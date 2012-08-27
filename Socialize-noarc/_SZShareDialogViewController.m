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
#import "SocializeThirdParty.h"
#import "SocializeLoadingView.h"
#import "SZStatusView.h"

@interface _SZShareDialogViewController () {
    dispatch_once_t _initToken;
}

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

    if ([self.title length] == 0) {
        self.title = @"Share";
    }
    
    __block __typeof__(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem redSocializeBarButtonWithTitle:@"Cancel" handler:^(id sender) {
        [self trackCloseEvent];
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
        __block id mySelf = self;
        (void)mySelf;
        [SZShareUtils shareViaSocialNetworksWithEntity:self.entity networks:networks options:shareOptions success:^(id<SZShare> share) {
            
            [self stopLoading];
            [self.createdShares addObject:share];
            BLOCK_CALL_1(self.completionBlock, self.createdShares);
            
            SZStatusView *status = [SZStatusView successStatusViewWithFrame:CGRectZero];
            [status showAndHideInKeyWindowWithDuration:2.];
            
        } failure:^(NSError *error) {
            [self stopLoading];
            [self failWithError:error];
        }];
        
        [self trackShareEventsForNetworks:networks];
    }
}

- (void)trackCloseEvent {
    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:@"close", @"action", nil];
    [[Socialize sharedSocialize] trackEventWithBucket:SHARE_DIALOG_BUCKET values:values];
}

- (void)trackOpenEvent {
    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:@"open", @"action", nil];
    [[Socialize sharedSocialize] trackEventWithBucket:SHARE_DIALOG_BUCKET values:values];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_once(&_initToken, ^{
        [self trackOpenEvent];
    });
}

@end
