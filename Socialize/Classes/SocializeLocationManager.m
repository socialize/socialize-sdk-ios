//
//  SocializeLocationManager.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/23/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLocationManager.h"
#import "SocializeCommonDefinitions.h"

static SocializeLocationManager *sharedLocationManager;

@implementation SocializeLocationManager
@synthesize locationManager = locationManager_;

- (void)dealloc {
    [locationManager_ setDelegate:nil];
    self.locationManager = nil;
    [super dealloc];
}

+ (void)load {
    // Always initialize the singleton
    (void)[[SocializeLocationManager sharedLocationManager] locationManager];
}

+ (SocializeLocationManager*)sharedLocationManager {
    if (sharedLocationManager == nil) {
        sharedLocationManager = [[SocializeLocationManager alloc] init];
    }
    return sharedLocationManager;
}

- (id)init {
    if (self = [super init]) {
        (void)self.locationManager;
    }
    
    return self;
}

- (CLLocationManager*)locationManager {
    if (locationManager_ == nil) {
        locationManager_ = [[CLLocationManager alloc] init];
        locationManager_.delegate = self;
    }
    return locationManager_;
}

+ (BOOL)locationServicesAvailable {
    //This is for backwards compatibilty with 4.0 devices.
    //Authorization status was not introduced until iOS 4.2
    if ([[CLLocationManager class] respondsToSelector:@selector(authorizationStatus)])
    {
        return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
    }
    
    return [CLLocationManager locationServicesEnabled];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSValue *statusValue = [NSValue valueWithBytes:&status objCType:@encode(CLAuthorizationStatus)];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:statusValue forKey:kSocializeCLAuthorizationStatusKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeCLAuthorizationStatusDidChangeNotification object:self userInfo:userInfo];
}

@end
