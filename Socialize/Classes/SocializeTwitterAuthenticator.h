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
#import "SocializeUIDisplay.h"
#import "SocializeAction.h"

@class Socialize;
@class SocializeTwitterAuthViewController;

@interface SocializeTwitterAuthenticator : SocializeAction <SocializeTwitterAuthViewControllerDelegate>

- (void)authenticateWithTwitter;

@property (nonatomic, retain) SocializeTwitterAuthViewController *twitterAuthViewController;
@property (nonatomic, copy) void (^successBlock)();
@property (nonatomic, copy) void (^failureBlock)(NSError *error);
@end
