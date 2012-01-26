/*
 * SocializeLocationManager.m
 * SocializeSDK
 *
 * Created on 9/14/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SocializeLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface SocializeLocationManager() 
    -(BOOL)shouldShareLocationOnStart;
@end

@implementation SocializeLocationManager

@synthesize shouldShareLocation = _shareLocation;
@synthesize currentLocationDescription = _currentLocationDescription;
@synthesize locationManager = locationManager_;
@synthesize delegate = delegate_;

+(SocializeLocationManager*)locationManager
{
    return [[[SocializeLocationManager alloc] init] autorelease];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _shareLocation = [self shouldShareLocationOnStart];
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

-(BOOL)shouldShareLocationOnStart
{
    if ([self applicationIsAuthorizedToUseLocationServices])
    {
        NSNumber * shareLocationBoolean = (NSNumber *)[[NSUserDefaults standardUserDefaults]valueForKey:@"post_comment_share_location"];
        return  (shareLocationBoolean !=nil)?[shareLocationBoolean boolValue]:YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)applicationIsAuthorizedToUseLocationServices;
{    
    //This is for backwards compatibilty with 4.0 devices.
    //Authorization status was not introduced until iOS 4.2
    if ([[CLLocationManager class] respondsToSelector:@selector(authorizationStatus)]) 
    {
        return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
    }
    
    return [CLLocationManager locationServicesEnabled];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self.delegate locationManager:self didChangeAuthorizationStatus:status];
}

-(void)dealloc
{
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:_shareLocation] forKey:@"post_comment_share_location"];
    [_currentLocationDescription release];
    self.locationManager = nil;
    [super dealloc];
}
@end
