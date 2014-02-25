//
//  SZViewUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/5/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZViewUtils.h"
#import "_Socialize.h"
#import "SDKHelpers.h"

@implementation SZViewUtils

+ (void)viewEntity:(id<SZEntity>)entity success:(void(^)(id<SZView> view))success failure:(void(^)(NSError *error))failure {
    id<SZView> view = [SZView viewWithEntity:entity];
    
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] createView:view success:success failure:failure];
    }, failure);
    
}

@end