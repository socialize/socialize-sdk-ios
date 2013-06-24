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

+ (BOOL) isAvailable
{
    return [[SZPinterestEngine sharedInstance]isAvailable];
}

+ (void)shareViaPinterestWithViewController:(UIViewController*)viewController
                                    options:(SZShareOptions*)options
                                     entity:(id<SZEntity>)entity
                                    success:(void(^)(id<SZShare> share))success
                                    failure:(void(^)(NSError *error))failure
{
    
    if (![self isAvailable]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializePinterestNotAvailable]);
        return;
    }
    
    [viewController showSocializeLoadingViewInSubview:nil];
    
    SZShare *share = [SZShare shareWithEntity:entity text:nil medium:SocializeShareMediumPinterest];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"pinterest"] forKey:@"third_parties"]];
    
    [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> serverShare) {
        SZPinterestShareData *pinterestData = [[SZPinterestShareData alloc] init];
        pinterestData.share = serverShare;
        pinterestData.propagationInfo = [[serverShare propagationInfoResponse] objectForKey:@"pinterest"];
        pinterestData.body = [SZShareUtils defaultMessageForShare:serverShare];
        BLOCK_CALL_1(options.willRedirectToPinterestBlock, pinterestData);
        
        [viewController hideSocializeLoadingView];
        
        SZPinterestEngine* engine = [SZPinterestEngine sharedInstance];
        [engine share:pinterestData.body imageURL:[NSURL URLWithString:entity.key] success:^{
            SZAuthWrapper(^{
                SZShare *share = [SZShare shareWithEntity:entity text:@"" medium:SocializeShareMediumPinterest];
                [[Socialize sharedSocialize] createShare:share success:^(id<SZShare> createdShare) {
                    BLOCK_CALL_1(success, createdShare);
                } failure:^(NSError *error) {
                    BLOCK_CALL_1(failure, error);
                }];
            }, ^(NSError *error) {
                BLOCK_CALL_1(failure, error);
            });
        } failure:^{
            BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializePinterestShareFailed]);
        }];
        
    } failure:^(NSError *error) {
        [viewController hideSocializeLoadingView];
    }];
}

@end
