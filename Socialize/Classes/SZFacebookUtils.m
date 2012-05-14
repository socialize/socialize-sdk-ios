//
//  SZFacebookUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZFacebookUtils.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeFacebookAuthHandler.h"
#import "_Socialize.h"
#import "UIAlertView+BlocksKit.h"

@implementation SZFacebookUtils

+ (BOOL)isAvailable {
    return [SocializeThirdPartyFacebook available];
}

+ (BOOL)isLinked {
    return [SocializeThirdPartyFacebook isLinkedToSocialize];
}

+ (void)linkToFacebookWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {

    NSString *facebookAppId = [SocializeThirdPartyFacebook facebookAppId];
    NSString *urlSchemeSuffix = [SocializeThirdPartyFacebook facebookUrlSchemeSuffix];
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil];

    NSString *title = @"Facebook Login Required";
    NSString *message = @"Do you want to log in with Facebook?";
    UIAlertView *alertView = [UIAlertView alertWithTitle:title message:message];
    
    [alertView setCancelButtonWithTitle:@"No" handler:^{
        failure([NSError defaultSocializeErrorForCode:SocializeErrorFacebookCancelledByUser]);
    }];
    
    [alertView addButtonWithTitle:@"Yes" handler:^{
        [[SocializeFacebookAuthHandler sharedFacebookAuthHandler]
         authenticateWithAppId:facebookAppId
         urlSchemeSuffix:urlSchemeSuffix
         permissions:permissions
         success:^(NSString *accessToken, NSDate *expirationDate) {
             [SocializeThirdPartyFacebook storeLocalCredentialsWithAccessToken:accessToken
                                                                expirationDate:expirationDate];
             
             [[Socialize sharedSocialize] linkToFacebookWithAccessToken:accessToken
                                                                success:success
                                                                failure:failure];
         } failure:failure];
    }];
}

@end
