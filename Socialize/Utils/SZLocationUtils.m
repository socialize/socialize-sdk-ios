//
//  SZLocationUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZLocationUtils.h"
#import <CoreLocation/CoreLocation.h>
#import "SocializeLocationManager.h"

@implementation SZLocationUtils

+ (void)getCurrentLocationWithSuccess:(void(^)(CLLocation* location))success failure:(void(^)(NSError *error))failure {
    [[SocializeLocationManager sharedLocationManager] getCurrentLocationWithSuccess:success failure:failure];
}

+ (CLLocation*)lastKnownLocation {
    return [[SocializeLocationManager sharedLocationManager] lastLocation];
}

@end
