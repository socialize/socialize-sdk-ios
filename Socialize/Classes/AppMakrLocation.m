//
//  Location.m
//  appbuildr
//
//  Created by PointAbout Dev on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppMakrLocation.h"

#define LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@implementation AppMakrLocation
@synthesize locationManager;
@synthesize lastKnownLocation;
@synthesize delegate;

static AppMakrLocation *sharedCLDelegate = nil;
- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		receivedLocationError = NO;
        self.locationManager.delegate = self; // Tells the location manager to send updates to this object
    }
    return self;
}
- (void)start {
    [self.locationManager startUpdatingLocation];
    __started = YES;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	[lastKnownLocation release];
	lastKnownLocation = newLocation;
	[lastKnownLocation retain];	
	NSNotification * notification = [NSNotification notificationWithName:OBSERVER_DID_LOCATION_UPDATE object:sharedCLDelegate];
	NSNotificationCenter * notificationCenter =  [NSNotificationCenter defaultCenter];
	[notificationCenter postNotification:notification];
}
+ (AppMakrLocation *)sharedInstance {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedCLDelegate;
}
- (BOOL) islocationServicesEnabled {

	return ( [CLLocationManager locationServicesEnabled] && !receivedLocationError );
}

+(BOOL)applicationIsAuthorizedToUseLocationServices;
{    
    //This is for backwards compatibilty with 4.0 devices.
    //Authorization status was not introduced until iOS 4.2
    if ([[CLLocationManager class] respondsToSelector:@selector(authorizationStatus)]) 
    {
        return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
    }
    
    return [CLLocationManager locationServicesEnabled];

}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [super allocWithZone:zone];
            return sharedCLDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	receivedLocationError = YES;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


- (void)dealloc {
    [locationManager release];
	[super dealloc];
}

@end
