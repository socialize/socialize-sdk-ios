//
//  SocializeLocationManager.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/23/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SocializeLocationManager : NSObject <CLLocationManagerDelegate>
+ (SocializeLocationManager*)sharedLocationManager;
+ (BOOL)locationServicesAvailable;
- (CLLocation*)currentLocation;
- (void)getCurrentLocationWithSuccess:(void(^)(CLLocation*))success failure:(void(^)(NSError*))failure;
- (void)tryToAcceptLocation:(CLLocation*)newLocation;

@property (nonatomic, readonly) CLLocation *currentLocation;
@end
