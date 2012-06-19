//
//  SocializeTwitterAuthViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeBaseViewControllerDelegate.h"

@class SocializeTwitterAuthViewController;

@protocol SocializeTwitterAuthViewControllerDelegate <SocializeBaseViewControllerDelegate>

@optional
- (void)twitterAuthViewController:(SocializeTwitterAuthViewController*)twitterAuthViewController
            didReceiveAccessToken:(NSString*)accessToken
                accessTokenSecret:(NSString*)accessTokenSecret
                       screenName:(NSString*)screenName
                           userID:(NSString*)userID;

@end
