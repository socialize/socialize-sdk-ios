//
//  SZTwitterUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZTwitterUtils.h"
#import "SocializeThirdPartyTwitter.h"
#import "_Socialize.h"
#import "SZTwitterLinkViewController.h"
#import "SDKHelpers.h"
#import "SZUserUtils.h"
#import "socialize_globals.h"
#import "SZOARequest+Twitter.h"
#import "NSOperationQueue+Socialize.h"

#define TWITTER_MAX_LENGTH 140
#define DISPLAYNAME_MAX_LENGTH 50

@implementation NSString (SZTwitterUtils)

- (NSString*)truncateForTwitterWithExtraCharacters:(NSUInteger)extraCharacters {
    NSInteger maxLength = TWITTER_MAX_LENGTH - extraCharacters;
    
    NSString *text = self;
    if ([text length] > maxLength) {
        text = [[text substringToIndex:maxLength - 1] stringByAppendingString:@"…"];
    }

    return text;
}

- (NSString*)truncateToMaxLength:(NSUInteger)maxLength {
    NSString *text = self;
    if ([text length] > maxLength) {
        text = [text substringToIndex:maxLength];
    }
    
    return text;
}

@end

@implementation SZTwitterUtils

+ (void)setConsumerKey:(NSString*)accessToken consumerSecret:(NSString*)consumerSecret {
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kSocializeTwitterAuthConsumerKey];
    [[NSUserDefaults standardUserDefaults] setObject:consumerSecret forKey:kSocializeTwitterAuthConsumerSecret];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)consumerKey {
    return [SocializeThirdPartyTwitter consumerKey];
}

+ (NSString*)consumerSecret {
    return [SocializeThirdPartyTwitter consumerSecret];
}

+ (NSString*)accessToken {
    return [SocializeThirdPartyTwitter accessToken];
}

+ (NSString*)accessTokenSecret {
    return [SocializeThirdPartyTwitter accessTokenSecret];
}

+ (BOOL)isAvailable {
    BOOL available = [SocializeThirdPartyTwitter available];
    if (!available) SZEmitUnconfiguredTwitterMessage();
    return available;
}

+ (BOOL)isLinked {
    return [SocializeThirdPartyTwitter isLinkedToSocialize];
}

+ (void)unlink {
    [SocializeThirdPartyTwitter removeLocalCredentials];
}

+ (void)linkWithAccessToken:(NSString*)accessToken accessTokenSecret:(NSString*)accessTokenSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    [SocializeThirdPartyTwitter storeLocalCredentialsWithAccessToken:accessToken accessTokenSecret:accessTokenSecret];
    
    [[Socialize sharedSocialize] linkToTwitterWithAccessToken:accessToken
                                            accessTokenSecret:accessTokenSecret
                                                      success:^(id<SZFullUser> user) {
                                                          [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kSocializeDontPostToTwitterKey];
                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                          BLOCK_CALL_1(success, user);
                                                      } failure:failure];
}

+ (void)linkWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure {
    NSString *consumerKey = [SocializeThirdPartyTwitter consumerKey];
    NSString *consumerSecret = [SocializeThirdPartyTwitter consumerSecret];
    
    SZTwitterLinkViewController *link = [[SZTwitterLinkViewController alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
    WEAK(viewController) weakViewController = viewController;

    link.completionBlock = ^{
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(success, [SZUserUtils currentUser]);
        }];
    };
    
    link.cancellationBlock = ^{
        [weakViewController SZDismissViewControllerAnimated:YES completion:^{
            BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorTwitterCancelledByUser]);
        }];
    };
    
    
    [viewController presentViewController:link animated:YES completion:nil];
}

+ (void)getWithViewController:(UIViewController*)viewController path:(NSString*)path params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    SZTWAuthWrapper(viewController, ^{
        SZOARequest *req = [SZOARequest twitterRequestWithMethod:@"GET" path:path parameters:params success:success failure:failure];
        [[NSOperationQueue socializeQueue] addOperation:req];
    }, failure);
}

+ (void)postWithViewController:(UIViewController*)viewController path:(NSString*)path params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    [self postWithViewController:viewController path:path params:params multipart:NO success:success failure:failure];
}

+ (void)postWithViewController:(UIViewController*)viewController path:(NSString*)path params:(NSDictionary*)params multipart:(BOOL)multipart success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    SZTWAuthWrapper(viewController, ^{
        SZOARequest *req = [SZOARequest twitterRequestWithMethod:@"POST" path:path parameters:params multipart:multipart success:success failure:failure];
        [[NSOperationQueue socializeQueue] addOperation:req];
    }, failure);
}

+ (void)getWithPath:(NSString*)path params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    SZOARequest *req = [SZOARequest twitterRequestWithMethod:@"GET" path:path parameters:params success:success failure:failure];
    [[NSOperationQueue socializeQueue] addOperation:req];
}

+ (void)postWithPath:(NSString*)path params:(NSDictionary*)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    SZOARequest *req = [SZOARequest twitterRequestWithMethod:@"POST" path:path parameters:params success:success failure:failure];
    [[NSOperationQueue socializeQueue] addOperation:req];
}

+ (NSString*)defaultTwitterTextForActivity:(id<SZActivity>)activity {
    NSAssert([activity isFromServer], @"Must be server activity");
    
    NSString *entityURL = [[[activity propagationInfoResponse] objectForKey:@"twitter"] objectForKey:@"entity_url"];
    NSString *displayName = [[activity entity] displayName];
    displayName = [displayName truncateToMaxLength:DISPLAYNAME_MAX_LENGTH];
    
    if ([activity conformsToProtocol:@protocol(SZShare)]) {
        id<SZShare> share = (id<SZShare>)activity;
        NSString *text = [share text];
        if ([text length] == 0) {
            text = @"Shared";
        }
        
        text = [text truncateForTwitterWithExtraCharacters:[displayName length] + [entityURL length] + 3];
        
        return [NSString stringWithFormat:@"%@, %@ %@", text, displayName, entityURL];
    } else if ([activity conformsToProtocol:@protocol(SZComment)]) {
        id<SZComment> comment = (id<SZComment>)activity;
        NSString *text = [comment text];
        
        text = [text truncateForTwitterWithExtraCharacters:[displayName length] + [entityURL length] + 3];

        return [NSString stringWithFormat:@"%@, %@ %@", text, displayName, entityURL];
    } else if ([activity conformsToProtocol:@protocol(SZLike)]) {
        
        return [NSString stringWithFormat:@"♥ Likes %@ %@", displayName, entityURL];
    }
    
    return nil;
}

@end
