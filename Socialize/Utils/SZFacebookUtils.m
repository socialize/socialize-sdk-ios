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
#import "SocializeFacebookInterface.h"
#import "SDKHelpers.h"

@implementation SZFacebookUtils

+ (void)setAccessToken:(NSString*)accessToken expirationDate:(NSDate*)expirationDate {
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kSocializeFacebookAuthAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:kSocializeFacebookAuthExpirationDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setAppId:(NSString*)appId {
    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:kSocializeFacebookAuthAppId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setURLSchemeSuffix:(NSString*)suffix {
    [[NSUserDefaults standardUserDefaults] setObject:suffix forKey:kSocializeFacebookAuthLocalAppId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)accessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeFacebookAuthAccessToken];
}

+ (NSDate*)expirationDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeFacebookAuthExpirationDate];
}

+ (NSString*)urlSchemeSuffix {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeFacebookAuthLocalAppId];
}

+ (NSArray*)requiredPermissions {
    return [NSArray arrayWithObjects:@"publish_stream", nil];
}

+ (BOOL)isAvailable {
    BOOL available = [SocializeThirdPartyFacebook available];
    if (!available) SZEmitUnconfiguredFacebookMessage();
    return available;
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
                                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                                           BLOCK_CALL_1(success, user);
                                                       } failure:failure];
}

+ (void)cancelLink {
    [[SocializeFacebookAuthHandler sharedFacebookAuthHandler] cancelAuthentication];
}

+ (void)linkWithOptions:(SZFacebookLinkOptions*)options success:(void(^)(id<SZFullUser>))success foreground:(void(^)())foreground failure:(void(^)(NSError *error))failure {
    if (options == nil) {
        options = [SZFacebookLinkOptions defaultOptions];
    }
    
    NSString *facebookAppId = [SocializeThirdPartyFacebook facebookAppId];
    NSString *urlSchemeSuffix = [SocializeThirdPartyFacebook facebookUrlSchemeSuffix];
    NSArray *permissions = options.permissions != nil ? options.permissions : [self requiredPermissions];
    
    [[SocializeFacebookAuthHandler sharedFacebookAuthHandler]
     authenticateWithAppId:facebookAppId
     urlSchemeSuffix:urlSchemeSuffix
     permissions:permissions
     success:^(NSString *accessToken, NSDate *expirationDate) {
         BLOCK_CALL(options.willSendLinkRequestToSocializeBlock);
         [self linkWithAccessToken:accessToken expirationDate:expirationDate success:^(id<SZFullUser> user) {
             BLOCK_CALL_1(success, user);
         } failure:^(NSError *error) {
             BLOCK_CALL_1(failure, error);
         }];
     } foreground:foreground failure:failure];
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

+ (void)postWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    SZFBAuthWrapper(^{
        [self sendRequestWithHTTPMethod:@"POST" graphPath:graphPath postData:params success:success failure:failure];
    }, failure);
}

+ (void)getWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    SZFBAuthWrapper(^{
        [self sendRequestWithHTTPMethod:@"GET" graphPath:graphPath postData:params success:success failure:failure];
    }, failure);
}

+ (void)deleteWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    SZFBAuthWrapper(^{
        [self sendRequestWithHTTPMethod:@"DELETE" graphPath:graphPath postData:params success:success failure:failure];
    }, failure);
}

@end