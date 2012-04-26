//
//  SocializeShareCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeShareCreator.h"
#import "_Socialize.h"

@implementation SocializeShareCreator

+ (void)createShare:(id<SocializeShare>)share
            options:(SocializeShareOptions*)options
            display:(id)display
            success:(void(^)(id<SocializeShare>))success
            failure:(void(^)(NSError *error))failure {
    
    SocializeShareCreator *creator = [[[SocializeShareCreator alloc] initWithActivity:share
                                                                              options:options
                                                                         displayProxy:nil
                                                                              display:display] autorelease];
    creator.activitySuccessBlock = success;
    creator.failureBlock = failure;
    [SocializeAction executeAction:creator];
}

+ (void)createShare:(id<SocializeShare>)share
            options:(SocializeShareOptions*)options
       displayProxy:(SocializeUIDisplayProxy*)displayProxy
            success:(void(^)(id<SocializeShare>))success
            failure:(void(^)(NSError *error))failure {
    
    SocializeShareCreator *creator = [[[SocializeShareCreator alloc] initWithActivity:share
                                                                              options:options
                                                                         displayProxy:displayProxy
                                                                              display:nil] autorelease];
    creator.activitySuccessBlock = success;
    creator.failureBlock = failure;
    [SocializeAction executeAction:creator];
}

- (id<SocializeShare>)share {
    return (id<SocializeShare>)self.activity;
}

- (NSString*)textForFacebook {
    NSString *entityURL = [self facebookEntityURLFromPropagationInfo];

    return [NSMutableString stringWithFormat:@"%@: \n %@", self.share.text, entityURL];
}

- (void)createActivityOnSocializeServer {
    [self.socialize createShare:self.share];
}

- (void)service:(SocializeService *)service didCreate:(id)objectOrObjects {
    NSAssert([objectOrObjects conformsToProtocol:@protocol(SocializeShare)], @"Not a share");
    
    [self succeedServerCreateWithActivity:objectOrObjects];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self failServerCreateWithError:error];
}

- (BOOL)shouldPostToFacebook {
    // Share third parties are not disabled by user settings
    return [self.thirdParties containsObject:@"facebook"];
}

- (BOOL)shouldPostToTwitter {
    // Share third parties are not disabled by user settings
    return [self.thirdParties containsObject:@"twitter"];
}

- (NSDictionary*)propagationInfoRequest {
    if (self.share.medium == SocializeShareMediumEmail) {
        return [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"email"] forKey:@"third_parties"];
    } else if (self.share.medium == SocializeShareMediumSMS) {
        return [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"sms"] forKey:@"third_parties"];
    } else {
        return [super propagationInfoRequest];
    }
}

/**
 Third parties is implied from medium for shares
 */
- (NSArray*)thirdParties {
    if (self.options.thirdParties != nil) {
        return self.options.thirdParties;
    }
    
    if (self.share.medium == SocializeShareMediumFacebook) {
        return [NSArray arrayWithObject:@"facebook"];
    } else if (self.share.medium == SocializeShareMediumTwitter) {
        return [NSArray arrayWithObject:@"twitter"];
    }
    
    return [NSArray array];
}


@end
