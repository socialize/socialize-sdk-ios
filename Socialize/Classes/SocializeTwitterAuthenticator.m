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

@interface SocializeTwitterAuthenticator ()
@property (nonatomic, assign) BOOL sentTokenToSocialize;
@end

@implementation SocializeTwitterAuthenticator
@synthesize twitterAuthViewController = twitterAuthViewController_;
@synthesize sentTokenToSocialize = sentTokenToSocialize_;
@synthesize successBlock = successBlock_;
@synthesize failureBlock = failureBlock_;

- (void)dealloc {
    [twitterAuthViewController_ setDelegate:nil];
    self.twitterAuthViewController = nil;
    
    [super dealloc];
}

- (void)cancelAllCallbacks {
    [twitterAuthViewController_ setDelegate:nil];
    [super cancelAllCallbacks];
}

- (SocializeTwitterAuthViewController*)twitterAuthViewController {
    if (twitterAuthViewController_ == nil) {
        twitterAuthViewController_ = [[SocializeTwitterAuthViewController alloc] init];
        twitterAuthViewController_.delegate = self;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        twitterAuthViewController_.consumerKey = [defaults objectForKey:kSocializeTwitterAuthConsumerKey];
        twitterAuthViewController_.consumerSecret = [defaults objectForKey:kSocializeTwitterAuthConsumerSecret];
    }
    
    return twitterAuthViewController_;
}

- (void)succeed {
    [self.display dismissController:self.twitterAuthViewController];
    
    if (self.successBlock != nil) {
        self.successBlock();
    }
}

- (void)failWithError:(NSError*)error {
    [self cancelAllCallbacks];
    [self.display dismissController:self.twitterAuthViewController];
    
    if (self.failureBlock != nil) {
        self.failureBlock(error);
    }
}

- (void)showTwitterAuthViewController {
    self.twitterAuthViewController = nil;
    UINavigationController *nav = [self.twitterAuthViewController wrappingSocializeNavigationController];
    [self.display displayController:nav];
}

- (void)tryToFinishAuthenticatingWithTwitter {
    if (![self.socialize twitterSessionValid]) {
        [self showTwitterAuthViewController];
        return;
    }
    
    if (!self.sentTokenToSocialize) {
        [self.socialize authenticateViaTwitterWithStoredCredentials];
        return;
    }

    [self succeed];
}

- (void)twitterAuthViewController:(SocializeTwitterAuthViewController *)twitterAuthViewController
            didReceiveAccessToken:(NSString *)accessToken
                accessTokenSecret:(NSString *)accessTokenSecret
                       screenName:(NSString *)screenName
                           userID:(NSString *)userID {

    // Successful auth -- store into the Socialize user defaults keys
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:kSocializeTwitterAuthAccessToken];
    [defaults setObject:accessTokenSecret forKey:kSocializeTwitterAuthAccessTokenSecret];
    [defaults setObject:screenName forKey:kSocializeTwitterAuthScreenName];
    [defaults synchronize];
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    /* The SocializeTwitterAuthViewController flow was cancelled by the user */
    
    NSError *error = [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser];
    [self failWithError:error];
}

- (void)baseViewControllerDidFinish:(SocializeBaseViewController *)baseViewController {
    /* The SocializeTwitterAuthViewController flow was completed successfully */

    [self tryToFinishAuthenticatingWithTwitter];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    self.sentTokenToSocialize = YES;
    [self tryToFinishAuthenticatingWithTwitter];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self failWithError:error];
}

- (void)authenticateWithTwitter {
    [self tryToFinishAuthenticatingWithTwitter];
}

@end
