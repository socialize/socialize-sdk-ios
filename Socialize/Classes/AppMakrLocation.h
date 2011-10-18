//
//  Location.h
//  appbuildr
//
//  Created by PointAbout Dev on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define OBSERVER_DID_LOCATION_UPDATE @"did_update_location"

@protocol LocationDelegate <NSObject>
@required
@end

@interface AppMakrLocation : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation		  *lastKnownLocation;
	BOOL			  receivedLocationError;
	id                delegate;
    BOOL              __started;
}

@property (nonatomic, retain) CLLocation *lastKnownLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic,assign) id <LocationDelegate> delegate;

- (void)start;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
- (BOOL) islocationServicesEnabled;
//+ (AppMakrLocation *)sharedInstance;
+ (BOOL) applicationIsAuthorizedToUseLocationServices;

@end