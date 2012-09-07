//
//  SZEventUtils.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/7/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZEventUtils.h"
#import <Socialize/Socialize.h>

@implementation SZEventUtils

+ (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure {
    SZAuthWrapper(^{
        [[Socialize sharedSocialize] trackEventWithBucket:bucket values:values success:success failure:failure];
    }, failure);
}

@end
