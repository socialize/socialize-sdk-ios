//
//  SocializeLocationManager.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/23/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLocationManager.h"
#import "SocializeCommonDefinitions.h"
#import <SZBlocksKit/BlocksKit.h>
#import "socialize_globals.h"

static SocializeLocationManager *sharedLocationManager;
static NSTimeInterval SocializeLocationManagerCurrentLocationExpireTime = 600.;
static NSTimeInterval SocializeLocationManagerWaitingForLocationTimeout = 10.;
static CLLocationDistance SocializeLocationManagerFixRequiredAccuracy = 200.;

@interface SocializeLocationManager ()
@end

@implementation SocializeLocationManager
@synthesize locationManager = locationManager_;
@synthesize lastLocation = lastLocation_;
@synthesize waitingForLocationTimer = waitingForLocationTimer_;
@synthesize waitingForLocation = waitingForLocation_;
@synthesize waitingForUserToEnableLocation = waitingForUserToEnableLocation_;
@synthesize locationCallbacks = locationCallbacks_;

- (void)dealloc {
    [locationManager_ setDelegate:nil];
    self.locationManager = nil;
    self.lastLocation = nil;
    self.locationCallbacks = nil;
    [waitingForLocationTimer_ invalidate];
    self.waitingForLocationTimer = nil;
    
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
        locationManager_.desiredAccuracy = kCLLocationAccuracyBest;
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

- (void)tryToAcceptLocation:(CLLocation*)newLocation {
    NSDate *newStamp = [newLocation timestamp];
    NSDate *nowStamp = [NSDate date];
    NSDate *currentStamp = [self.currentLocation timestamp];
    
    // Not newer than the current location
    if ([newStamp timeIntervalSinceDate:currentStamp] <= 0) {
        return;
    }
    
    // Already expired
    if ([nowStamp timeIntervalSinceDate:newStamp] > SocializeLocationManagerCurrentLocationExpireTime)
        return;
    
    // Too inaccurate
    if ([newLocation horizontalAccuracy] > SocializeLocationManagerFixRequiredAccuracy)
        return;
    
    [self acceptNewLocation:newLocation];
}

- (void)sendNotificationForNewLocation:(CLLocation*)newLocation {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:newLocation forKey:kSZNewLocationKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:SZLocationDidChangeNotification object:self userInfo:userInfo];
}

- (void)acceptNewLocation:(CLLocation*)newLocation {
    self.lastLocation = newLocation;
    [self sendNotificationForNewLocation:newLocation];
    [self succeedWaitingForLocationWithLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSValue *statusValue = [NSValue valueWithBytes:&status objCType:@encode(CLAuthorizationStatus)];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:statusValue forKey:kSocializeCLAuthorizationStatusKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeCLAuthorizationStatusDidChangeNotification object:self userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self tryToAcceptLocation:newLocation];
    
    if (self.waitingForUserToEnableLocation) {
        // User enabled location, we were waiting for this
        self.waitingForUserToEnableLocation = NO;
        
        if ([self.locationCallbacks count] > 0) {
            // Location must not have been accepted since we still have callbacks, so start the timer
            [self startWaitingForLocationTimer];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This method of determining rejection is compatible with iOS 4 and later
        NSError *error = [NSError defaultSocializeErrorForCode:SocializeErrorLocationUpdateRejectedByUser];
        [self failWaitingForLocationWithError:error];
    }
}

- (NSMutableArray*)locationCallbacks {
    if (locationCallbacks_ == nil) {
        locationCallbacks_ = [[NSMutableArray alloc] init];
    }
    
    return locationCallbacks_;
}

- (CLLocation*)currentLocation {
    if ([[NSDate date] timeIntervalSinceDate:self.lastLocation.timestamp] < SocializeLocationManagerCurrentLocationExpireTime) {
        return self.lastLocation;
    }
    
    return nil;
}

- (void)callAndClearLocationSuccessCallbacksWithLocation:(CLLocation*)location {

    for (NSArray *pair in self.locationCallbacks) {
        id blockObject = [pair objectAtIndex:0];
        if (blockObject == [NSNull null])
            continue;

        void (^successBlock)(CLLocation*) = blockObject;
        successBlock(location);
    }
    [self.locationCallbacks removeAllObjects];
}

- (void)callAndClearLocationFailureCallbacksWithError:(NSError*)error {
    
    for (NSArray *pair in self.locationCallbacks) {
        id failObject = [pair objectAtIndex:1];
        if (failObject == [NSNull null])
            continue;
        
        void (^failureBlock)(NSError*) = [pair objectAtIndex:1];
        failureBlock(error);
    }
    [self.locationCallbacks removeAllObjects];
}

- (void)stopWaitingForLocationTimer {
    [self.waitingForLocationTimer invalidate];
    self.waitingForLocationTimer = nil;
}

- (void)startWaitingForLocationTimer {
    WEAK(self) weakSelf = self;
    self.waitingForLocationTimer = [NSTimer bk_scheduledTimerWithTimeInterval:SocializeLocationManagerWaitingForLocationTimeout
                                                                        block:^(NSTimer *timer) {
                                                                            NSError *error = [NSError defaultSocializeErrorForCode:SocializeErrorLocationUpdateTimedOut];
                                                                            [weakSelf failWaitingForLocationWithError:error];
                                                                        }
                                                                      repeats:NO];
}

- (void)startWaitingForLocation {
    if (self.waitingForLocation)
        return;
    
    self.waitingForLocation = YES;
    [self.locationManager startUpdatingLocation];
    
    if ([[self class] locationServicesAvailable]) {
        [self startWaitingForLocationTimer];
    } else {
        // Do not start the timer until location services are available.
        self.waitingForUserToEnableLocation = YES;
    }
}

- (void)stopWaitingForLocation {
    self.waitingForLocation = NO;
    [self stopWaitingForLocationTimer];
    [self.locationManager stopUpdatingLocation];
}

- (void)succeedWaitingForLocationWithLocation:(CLLocation*)location {
    [self stopWaitingForLocation];
    [self callAndClearLocationSuccessCallbacksWithLocation:location];
}

- (void)failWaitingForLocationWithError:(NSError*)error {
    [self stopWaitingForLocation];
    [self callAndClearLocationFailureCallbacksWithError:error];
}

- (id)blockCopyOrNSNull:(id)block {
    if (block != nil) {
        return [[block copy] autorelease];
    } else {
        return [NSNull null];
    }
}

- (void)getCurrentLocationWithSuccess:(void(^)(CLLocation*))success failure:(void(^)(NSError*))failure {
    CLLocation *currentLocation = [self currentLocation];
    if (currentLocation != nil) {
        success(currentLocation);
        return;
    }

    [self.locationCallbacks addObject:[NSArray arrayWithObjects:[self blockCopyOrNSNull:success], [self blockCopyOrNSNull:failure], nil]];

    if (!self.waitingForLocation) {
        [self startWaitingForLocation];
    }
}

@end
