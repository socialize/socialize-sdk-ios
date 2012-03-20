//
//  SocializeTwitterAuthenticator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTwitterAuthenticator.h"
#import "_Socialize.h"
#import "SocializeTwitterAuthViewController.h"
#import "UINavigationController+Socialize.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyTwitter.h"

@interface SocializeTwitterAuthenticator ()
- (void)showTwitterAuthViewController;
@end

@implementation SocializeTwitterAuthenticator
@synthesize twitterAuthViewController = twitterAuthViewController_;
@synthesize options = options_;

- (void)dealloc {
    self.options = nil;
    
    [super dealloc];
}

- (void)destroyUI {
    [twitterAuthViewController_ setDelegate:nil];
    self.twitterAuthViewController = nil;
}

+ (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                                  display:(id)display
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure {
    SocializeTwitterAuthenticator *auth = [[[self alloc] initWithOptions:options display:display] autorelease];
    auth.successBlock = success;
    auth.failureBlock = failure;

    [SocializeAction executeAction:auth];
}

+ (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                           displayProxy:(SocializeUIDisplayProxy*)proxy
                                success:(void(^)())success
                                failure:(void(^)(NSError *error))failure {
    SocializeTwitterAuthenticator *auth = [[[self alloc] initWithOptions:options displayProxy:proxy] autorelease];
    auth.successBlock = success;
    auth.failureBlock = failure;
    
    [SocializeAction executeAction:auth];
}

- (Class)thirdParty {
    return [SocializeThirdPartyTwitter class];
}

- (void)showSettings {
    // Temporary hotfix for iOS 4.2 and earlier
    UINavigationController *settings = [self createSettings];
    [self.twitterAuthViewController presentModalViewController:settings animated:YES];
}

- (void)willSucceed {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY];
    [defaults synchronize];
}

- (void)cancelAllCallbacks {
    [twitterAuthViewController_ setDelegate:nil];
    [super cancelAllCallbacks];
}

- (void)attemptInteractiveLogin {
    [self showTwitterAuthViewController];
}

- (void)showTwitterAuthViewController {
    self.twitterAuthViewController = [[[SocializeTwitterAuthViewController alloc] init] autorelease];
    self.twitterAuthViewController.delegate = self;
    
    self.twitterAuthViewController.consumerKey = [SocializeThirdPartyTwitter consumerKey];
    self.twitterAuthViewController.consumerSecret = [SocializeThirdPartyTwitter consumerSecret];
    UINavigationController *nav = [self.twitterAuthViewController wrappingSocializeNavigationController];
    [self.displayProxy presentModalViewController:nav];
}

- (void)twitterAuthViewController:(SocializeTwitterAuthViewController *)twitterAuthViewController
            didReceiveAccessToken:(NSString *)accessToken
                accessTokenSecret:(NSString *)accessTokenSecret
                       screenName:(NSString *)screenName
                           userID:(NSString *)userID {

    [SocializeThirdPartyTwitter storeLocalCredentialsWithAccessToken:accessToken
                                                   accessTokenSecret:accessTokenSecret];
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    if (baseViewController == self.twitterAuthViewController) {
        /* The SocializeTwitterAuthViewController flow was cancelled by the user */

        NSError *error = [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser];
        [self failWithError:error];
    } else {
        [super baseViewControllerDidCancel:baseViewController];
    }
}

- (void)baseViewControllerDidFinish:(SocializeBaseViewController *)baseViewController {
    if (baseViewController == self.twitterAuthViewController) {
        /* The SocializeTwitterAuthViewController flow was completed successfully */

        [self succeedInteractiveLogin];
    }
}

@end
