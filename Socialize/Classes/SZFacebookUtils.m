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
#import "SocializeFacebookInterface.h"

@implementation SZFacebookUtils

+ (void)setAppId:(NSString*)appId expirationDate:(NSDate*)expirationDate {
    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:kSocializeFacebookAuthAppId];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:kSocializeFacebookAuthExpirationDate];
}

+ (void)setURLSchemeSuffix:(NSString*)suffix {
    [[NSUserDefaults standardUserDefaults] setObject:suffix forKey:kSocializeFacebookAuthLocalAppId];
}

+ (NSString*)accessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeFacebookAuthAccessToken];
}

+ (NSDate*)expirationDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeFacebookAuthExpirationDate];
}

+ (BOOL)isAvailable {
    return [SocializeThirdPartyFacebook available];
}

+ (BOOL)isLinked {
    return [SocializeThirdPartyFacebook isLinkedToSocialize];
}

+ (void)unlink {
    [SocializeThirdPartyFacebook removeLocalCredentials];
}

+ (void)linkWithAccessToken:(NSString*)accessToken expirationDate:(NSDate*)expirationDate success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    [SocializeThirdPartyFacebook storeLocalCredentialsWithAccessToken:accessToken
                                                       expirationDate:expirationDate];
    
    [[Socialize sharedSocialize] linkToFacebookWithAccessToken:accessToken
                                                expirationDate:expirationDate
                                                       success:^(id<SZFullUser> user) {
                                                           [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kSocializeDontPostToFacebookKey];
                                                           success(user);
                                                       } failure:failure];
}

+ (void)linkWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {

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
             [self linkWithAccessToken:accessToken expirationDate:expirationDate success:success failure:failure];
         } failure:failure];
    }];
    
    [alertView show];
}

+ (void)sendRequestWithHTTPMethod:(NSString*)method graphPath:(NSString*)graphPath postData:(NSDictionary*)postData success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    [[SocializeFacebookInterface sharedFacebookInterface] requestWithGraphPath:graphPath params:postData httpMethod:method completion:^(id result, NSError *error) {
        if (error != nil) {
            BLOCK_CALL_1(failure, error);
            return;
        } else {
            BLOCK_CALL_1(success, result);
        }
    }];
}

+ (void)postWithGraphPath:(NSString*)graphPath postData:(NSDictionary*)postData success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    [self sendRequestWithHTTPMethod:@"POST" graphPath:graphPath postData:postData success:success failure:failure];
}

+ (void)getWithGraphPath:(NSString*)graphPath postData:(NSDictionary*)postData success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    [self sendRequestWithHTTPMethod:@"GET" graphPath:graphPath postData:postData success:success failure:failure];
}

+ (void)deleteWithGraphPath:(NSString*)graphPath postData:(NSDictionary*)postData success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    [self sendRequestWithHTTPMethod:@"DELETE" graphPath:graphPath postData:postData success:success failure:failure];
}

@end