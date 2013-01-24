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
#import "SZEventUtils.h"
#import "SocializeLoadingView.h"
#import "SZStatusView.h"
#import "SocializeComposeMessageViewController.h"

@interface _SZShareDialogViewController () {
    dispatch_once_t _initToken;
}

@end

@implementation _SZShareDialogViewController
@synthesize completionBlock = _completionBlock;
@synthesize cancellationBlock = _cancellationBlock;

- (void)dealloc {
    self.completionBlock = nil;
    self.cancellationBlock = nil;
    
    [super dealloc];
}

- (id)initWithEntity:(id<SocializeEntity>)entity {
    if (self = [super initWithEntity:entity]) {
        self.disableAutopostSelection = YES;
        self.showOtherShareTypes = YES;
    }
    return self;
}

- (void)cancel {
    [self trackCloseEvent];
    BLOCK_CALL(self.cancellationBlock);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.title length] == 0) {
        self.title = @"Share";
    }
    
    __block __typeof__(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem redSocializeBarButtonWithTitle:@"Cancel" handler:^(id sender) {
        [weakSelf cancel];
    }];
}

- (void)continueButtonPressed:(id)sender {
    SZSocialNetwork networks = [self selectedNetworks];
    
    if (networks == SZSocialNetworkNone) {
        [UIAlertView showAlertWithTitle:@"Select a Network" message:@"One or more networks must be selected to perform a share" buttonTitle:@"Ok" handler:nil];
    } else {
        
        SocializeComposeMessageViewController *message = [[[SocializeComposeMessageViewController alloc] initWithEntity:self.entity] autorelease];
        __block __unsafe_unretained SocializeComposeMessageViewController *weakMessage = message;

        message.completionBlock = ^{
            [weakMessage startLoading];
            
            SZShareOptions *options = [self optionsForShare];
            if ([options.text length] == 0) {
                options.text = weakMessage.commentTextView.text;
            }
            options.dontShareLocation = !weakMessage.shouldShareLocation;
            
            [SZShareUtils shareViaSocialNetworksWithEntity:self.entity networks:networks options:options success:^(id<SZShare> share) {
                [weakMessage stopLoading];

                [self.createdShares addObject:share];
                BLOCK_CALL_1(self.completionBlock, self.createdShares);
                
                [self.SZPresentingViewController SZDismissViewControllerAnimated:YES completion:nil];
                [self.display socializeRequiresIndicationOfStatusForContext:SZStatusContextSocializeShareCompleted];
                

            } failure:^(NSError *error) {
                [weakMessage stopLoading];
                [self failWithError:error];
            }];
            
            [self trackShareEventsForNetworks:networks];
        };

        message.cancellationBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        [self.navigationController pushViewController:message animated:YES];
        [message.navigationItem.leftBarButtonItem changeTitleOnCustomButtonToText:@"Back" type:AMSOCIALIZE_BUTTON_TYPE_BLUE];
    }
}

- (void)trackCloseEvent {
    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:@"close", @"action", nil];
    [SZEventUtils trackEventWithBucket:SHARE_DIALOG_BUCKET values:values success:nil failure:nil];

}

- (void)trackOpenEvent {
    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:@"open", @"action", nil];
    [SZEventUtils trackEventWithBucket:SHARE_DIALOG_BUCKET values:values success:nil failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_once(&_initToken, ^{
        [self trackOpenEvent];
    });
}

@end
