//
//  SocializeTwitterAuthenticator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeServiceDelegate.h"
#import "SocializeTwitterAuthViewControllerDelegate.h"
#import "SocializeTwitterAuthenticatorDelegate.h"

@class Socialize;
@class SocializeTwitterAuthViewController;

@interface SocializeTwitterAuthenticator : NSObject <SocializeServiceDelegate, SocializeTwitterAuthViewControllerDelegate>

- (void)authenticateWithTwitter;

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) UIViewController *modalPresentationTarget;
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) SocializeTwitterAuthViewController *twitterAuthViewController;

@end
