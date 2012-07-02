//
//  SZLocationUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SZLocationUtils : NSObject
+ (void)getCurrentLocationWithSuccess:(void(^)(CLLocation* location))success failure:(void(^)(NSError *error))failure;
+ (CLLocation*)lastKnownLocation;

@end
