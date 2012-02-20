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
@synthesize delegate = delegate_;
@synthesize socialize = socialize_;
@synthesize twitterAuthViewController = twitterAuthViewController_;
@synthesize modalPresentationTarget = modalPresentationTarget_;
@synthesize sentTokenToSocialize = sentTokenToSocialize_;

- (void)dealloc {
    self.socialize = nil;
    [twitterAuthViewController_ setDelegate:nil];
    self.twitterAuthViewController = nil;
    self.modalPresentationTarget = nil;
    
    [super dealloc];
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    return socialize_;
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

- (void)dismissController:(UIViewController*)controller {
    if ([self.delegate respondsToSelector:@selector(twitterAuthenticator:requiresDismissOfViewController:)]) {
        [self.delegate twitterAuthenticator:self requiresDismissOfViewController:controller];
    } else if (self.modalPresentationTarget != nil) {
        [self.modalPresentationTarget dismissModalViewControllerAnimated:YES];
    } else {
        NSAssert(NO, @"Delegate implementation error. You MUST implement either twitterAuthenticator:requiresDismissOfViewController: or modalPresentationTargetForTwitterAuthenticator:");
    }
}

- (void)succeed {
    [self dismissController:self.twitterAuthViewController];

    if ([self.delegate respondsToSelector:@selector(twitterAuthenticatorDidSucceed:)]) {
        [self.delegate twitterAuthenticatorDidSucceed:self];
    }
}

- (void)failWithError:(NSError*)error {
    [self dismissController:self.twitterAuthViewController];

    if ([self.delegate respondsToSelector:@selector(twitterAuthenticator:didFailWithError:)]) {
        [self.delegate twitterAuthenticator:self didFailWithError:error];
    }
}

- (UIViewController*)modalPresentationTarget {
    if (modalPresentationTarget_ == nil) {
        if ([self.delegate respondsToSelector:@selector(twitterAuthenticatorRequiresModalPresentationTarget:)]) {
            modalPresentationTarget_ = [[self.delegate twitterAuthenticatorRequiresModalPresentationTarget:self] retain];
        }
    }
    
    return modalPresentationTarget_;
}

- (void)displayController:(UIViewController*)controller {
    if ([self.delegate respondsToSelector:@selector(twitterAuthenticator:requiresDisplayOfViewController:)]) {
        [self.delegate twitterAuthenticator:self requiresDisplayOfViewController:controller];
    } else if (self.modalPresentationTarget != nil) {
        [self.modalPresentationTarget presentModalViewController:controller animated:YES];
    } else {
        NSAssert(NO, @"Delegate implementation error. You MUST implement either twitterAuthenticator:requiresDisplayOfViewController: or modalPresentationTargetForTwitterAuthenticator:");
    }
}

- (void)showTwitterAuthViewController {
    self.twitterAuthViewController = nil;
    UINavigationController *nav = [self.twitterAuthViewController wrappingSocializeNavigationController];
    [self displayController:nav];
}

- (void)tryToFinishAuthenticatingWithTwitter {
    if (![self.socialize twitterSessionValid]) {
        [self showTwitterAuthViewController];
        return;
    }
    
    if (!self.sentTokenToSocialize) {
        [self.socialize authenticateWithTwitterUsingStoredCredentials];
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
    
    // Let the delegate know, if they care
    if ([self.delegate respondsToSelector:@selector(twitterAuthenticator:didReceiveAccessToken:accessTokenSecret:screenName:userID:)]) {
        [self.delegate twitterAuthenticator:self didReceiveAccessToken:accessToken accessTokenSecret:accessTokenSecret screenName:screenName userID:userID];
    }
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
