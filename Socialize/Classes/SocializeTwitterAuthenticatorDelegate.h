//
//  SocializeTwitterAuthenticatorDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SocializeTwitterAuthenticator;

@protocol SocializeTwitterAuthenticatorDelegate <NSObject>

@optional

/* If the auth process needs to present a twitter authentication dialog, it automatically present/dismiss on the response from this message */
- (UIViewController*)twitterAuthenticatorRequiresModalPresentationTarget:(SocializeTwitterAuthenticator*)twitterAuthenticator;

/* If you would like more explicit control of the presentation process, you can implement the following two messages.
   If both are implemented, the modalPresentationTarget above will not be used. */
- (void)twitterAuthenticator:(SocializeTwitterAuthenticator*)twitterAuthenticator requiresDisplayOfViewController:(UIViewController*)controller;
- (void)twitterAuthenticator:(SocializeTwitterAuthenticator*)twitterAuthenticator requiresDismissOfViewController:(UIViewController*)controller;

/* Called when we receive an access token from the actual Twitter auth flow */
- (void)twitterAuthenticator:(SocializeTwitterAuthenticator*)twitterAuthenticator
       didReceiveAccessToken:(NSString *)accessToken
           accessTokenSecret:(NSString *)accessTokenSecret
                  screenName:(NSString *)screenName
                      userID:(NSString *)userID;

/* Called when both twitter auth flow is complete and twitter account has been successfully linked with Socialize account */
- (void)twitterAuthenticatorDidSucceed:(SocializeTwitterAuthenticator*)twitterAuthenticator;

/* Called when something has gone wrong */
- (void)twitterAuthenticator:(SocializeTwitterAuthenticator*)twitterAuthenticator didFailWithError:(NSError*)error;

@end
