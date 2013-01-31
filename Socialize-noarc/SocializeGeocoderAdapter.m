/*
 * SocializeGeocoderAdapter.m
 * SocializeSDK
 *
 * Created on 10/12/11.
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

#import "SocializeGeocoderAdapter.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >=  __IPHONE_5_0

@implementation SocializeGeocoderAdapter

-(id)init
{
    self = [super init];
    if(self)
    {
        geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

-(void)dealloc
{ 
    [geocoder cancelGeocode];
    [geocoder release];
    [super dealloc];
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler
{
    [geocoder reverseGeocodeLocation: location completionHandler: completionHandler];
}

- (void)cancelGeocode
{
    
}

@end

#else
@interface SocializeGeocoderAdapter()
@property(nonatomic, copy) CLGeocodeCompletionHandler handler;
@property(nonatomic, retain) MKReverseGeocoder* _geocoder;
@end

@implementation SocializeGeocoderAdapter
@synthesize handler;
@synthesize _geocoder;

- (void) dealloc
{
    _geocoder.delegate = nil;
    [_geocoder release];
    [handler release];
    [super dealloc];
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler
{
    if(_geocoder.isQuerying)
        return;
    
    _geocoder = [[MKReverseGeocoder alloc]initWithCoordinate:location.coordinate];
    _geocoder.delegate = self;
    self.handler = [[completionHandler copy] autorelease];
    [_geocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    handler([NSArray arrayWithObject:placemark], nil);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    handler(nil, error);
}

- (void)cancelGeocode
{
    [_geocoder cancel];
}

@end

#endif
