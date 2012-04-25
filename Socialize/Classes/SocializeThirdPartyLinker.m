//
//  SocializeThirdPartyLinker.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdPartyLinker.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeThirdParty.h"
#import "SocializeErrorDefinitions.h"

@interface SocializeThirdPartyLinker ()
@property (nonatomic, assign) BOOL finishedShowingAuthDialog;
@property (nonatomic, retain) SocializeAuthViewController *authViewController;
@end

@implementation SocializeThirdPartyLinker
@synthesize finishedShowingAuthDialog = finishedShowingAuthDialog_;
@synthesize authViewController = authViewController_;

+ (void)linkToThirdPartyWithOptions:(SocializeThirdPartyLinkOptions*)options
                       displayProxy:(SocializeUIDisplayProxy*)displayProxy
                            success:(void(^)())success
                            failure:(void(^)(NSError *error))failure {
    SocializeThirdPartyLinker *linker = [[[SocializeThirdPartyLinker alloc]
                                          initWithOptions:options displayProxy:displayProxy display:nil]
                                         autorelease];
    linker.successBlock = success;
    linker.failureBlock = failure;
    
    [SocializeAction executeAction:linker];
}

- (void)dealloc {
    self.authViewController = nil;

    [super dealloc];
}

- (void)tryToFinishLinking {
    if (!self.finishedShowingAuthDialog && ![SocializeThirdParty thirdPartyLinked]) {
        [self showAuthViewController];
        return;
    }
    
    [self succeed];
}

- (void)socializeAuthViewController:(SocializeAuthViewController *)authViewController didAuthenticate:(id<SocializeUser>)user {
    self.finishedShowingAuthDialog = YES;
    [self.displayProxy dismissModalViewController:self.authViewController];
    
    [self tryToFinishLinking];
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    [self.displayProxy dismissModalViewController:self.authViewController.navigationController];
    [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorThirdPartyLinkCancelledByUser]];
}

- (void)authorizationSkipped {
    self.finishedShowingAuthDialog = YES;
    [self.displayProxy dismissModalViewController:self.authViewController];
    
    [self tryToFinishLinking];
}

- (void)showAuthViewController {
    self.authViewController = [[[SocializeAuthViewController alloc] initWithDelegate:self] autorelease];
    UINavigationController *nav = [UINavigationController socializeNavigationControllerWithRootViewController:self.authViewController];
    [self.displayProxy presentModalViewController:nav];
}

- (void)executeAction {
    [self tryToFinishLinking];
}


@end
