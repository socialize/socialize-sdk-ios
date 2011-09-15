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
#import "NSString+PlaceMark.h"
#import "AppMakrLocation.h"

@interface SocializeLocationManager() 
    -(BOOL)shouldShareLocationOnStart;
@end

@implementation SocializeLocationManager

@synthesize shouldShareLocation = _shareLocation;
@synthesize currentLocationDescription = _currentLocationDescription;

+(SocializeLocationManager*)create
{
    return [[[SocializeLocationManager alloc] init] autorelease];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _shareLocation = [self shouldShareLocationOnStart];
    }
    return self;
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

-(void)findLocationDescriptionWithCoordinate: (CLLocationCoordinate2D) coordinate  andWithBlock:(OnFoundCallbackBlock)block
{
    NSAssert(geoCoder == nil, @"Should be just one instance of geo coder in the same time");
    onFoundblock = [block copy];
    geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
    geoCoder.delegate = self;
    [geoCoder start];
}

-(BOOL)applicationIsAuthorizedToUseLocationServices
{
    return [AppMakrLocation applicationIsAuthorizedToUseLocationServices];
}

-(void)dealloc
{
    [geoCoder cancel];
    [geoCoder release];
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:_shareLocation] forKey:@"post_comment_share_location"];
    [super dealloc];
}

#pragma mark - Reverse geo coder delegate
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark 
{   
    self.currentLocationDescription  = [NSString stringWithPlacemark:placemark];
    onFoundblock(_currentLocationDescription);
    [onFoundblock release]; onFoundblock = nil;
    
    geocoder.delegate = nil;
    [geocoder release]; geoCoder = nil;
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);

    self.currentLocationDescription = @"Could not locate the place name";
    onFoundblock(_currentLocationDescription);
    [onFoundblock release]; onFoundblock = nil;
    
    geocoder.delegate = nil;
    [geocoder release]; geoCoder = nil;
}
@end
