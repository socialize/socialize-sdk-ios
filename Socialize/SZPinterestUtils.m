//
//  SZPinterestUtils.m
//  Socialize
//
//  Created by Sergey Popenko on 6/24/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZPinterestUtils.h"
#import "NSError+Socialize.h"
#import "SDKHelpers.h"
#import "Socialize.h"
#import "SZPinterestEngine.h"

@implementation SZPinterestUtils

+ (void) setApplicationId: (NSString*) appID
{
    [[SZPinterestEngine sharedInstance] setApplicationId:appID];
}

+ (BOOL) isAvailable
{
    return [[SZPinterestEngine sharedInstance]isAvailable];
}

+ (NSString*)propogationUrl:(id<SZShare>)share {
    NSDictionary *info = [[[share propagationInfoResponse] allValues] lastObject];
    return [info objectForKey:@"entity_url"];
}


+ (NSString*)defaultMessageForShare:(id<SZShare>)share {
    NSDictionary *info = [[[share propagationInfoResponse] allValues] lastObject];
    NSString *entityURL = [info objectForKey:@"entity_url"];
    NSString *applicationURL = [info objectForKey:@"application_url"];
    
    id<SocializeEntity> e = share.entity;
    
    NSMutableString *msg = [NSMutableString stringWithString:@"I thought you would find this interesting: "];
    
    if ([e.name length] > 0) {
        [msg appendFormat:@"%@ ", e.name];
    }
    
    NSString *applicationName = [share.application name];
    
    [msg appendFormat:@"%@\n\nSent from %@ (%@)", entityURL, applicationName, applicationURL];
    
    return msg;
}


+ (void)shareViaPinterestWithViewController:(UIViewController*)viewController
                                    options:(SZShareOptions*)options
                                     entity:(id<SZEntity>)entity
                                    success:(void(^)(id<SZShare> share))success
                                    failure:(void(^)(NSError *error))failure {
    if(![self isAvailable]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializePinterestNotAvailable]);
        return;
    }
    
    [viewController showSocializeLoadingViewInSubview:nil];
    
    SZShare *share = [SZShare shareWithEntity:entity text:nil medium:SocializeShareMediumOther];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"facebook"] forKey:@"third_parties"]];
    
    [[Socialize sharedSocialize] createShare:share
                                     success:^(id<SZShare> serverShare) {
                                         [SZPinterestUtils shareSuccess:serverShare
                                                         viewController:viewController
                                                                options:options
                                                                 entity:entity
                                                                success:success
                                                                failure:failure];
                                     }
                                     failure:^(NSError *error) {
                                         [viewController hideSocializeLoadingView];
                                         BLOCK_CALL_1(failure, error);
                                     }];
}

//successful share create
+ (void)shareSuccess:(id<SZShare>)serverShare
      viewController:(UIViewController*)viewController
             options:(SZShareOptions*)options
              entity:(id<SZEntity>)entity
             success:(void(^)(id<SZShare> share))success
             failure:(void(^)(NSError *error))failure {
    SZPinterestShareData *pinterestData = [[SZPinterestShareData alloc] init];
    pinterestData.share = serverShare;
    pinterestData.propagationInfo = [[serverShare propagationInfoResponse] objectForKey:@"facebook"];
    pinterestData.body = [SZPinterestUtils defaultMessageForShare:serverShare];
    BLOCK_CALL_1(options.willRedirectToPinterestBlock, pinterestData);
    [viewController hideSocializeLoadingView];
    SZPinterestEngine* engine = [SZPinterestEngine sharedInstance];
    NSURL* imageUrl = [NSURL URLWithString:entity.key];
    NSURL* sourceUrl = [NSURL URLWithString:[self propogationUrl:serverShare]];
    
    [engine share:pinterestData.body
         imageURL:imageUrl
        sourceUrl:sourceUrl
          success:^{
              [SZPinterestUtils engineShareSuccess:entity success:success failure:failure];
          }
          failure:^{
              BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializePinterestShareFailed]);
          }];
    
}

//successful share create
+ (void)engineShareSuccess:(id<SZEntity>)entity
                   success:(void(^)(id<SZShare> share))success
                   failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        SZShare *share = [SZShare shareWithEntity:entity
                                             text:@""
                                           medium:SocializeShareMediumOther];
        [[Socialize sharedSocialize] createShare:share
                                         success:^(id<SZShare> createdShare) {
                                             BLOCK_CALL_1(success, createdShare);
                                         }
                                         failure:^(NSError *error) {
                                             BLOCK_CALL_1(failure, error);
                                         }];
    },
                  ^(NSError *error) {
                      BLOCK_CALL_1(failure, error);
                  });
}

@end
