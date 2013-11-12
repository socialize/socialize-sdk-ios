//
//  TestAppHelper.m
//  Socialize
//
//  Created by Sergey Popenko on 9/23/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "TestAppHelper.h"
#import "StringHelper.h"

static NSString *UUIDString() {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

static NSString *TestAppKIFTestControllerRunID = nil;

@implementation TestAppHelper
+(NSDictionary*)authInfoFromConfig
{
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    NSString * configPath = [bundle pathForResource:@"SocializeApiInfo" ofType:@"plist"];
    NSDictionary * configurationDictionary = [[NSDictionary alloc]initWithContentsOfFile:configPath];
    return  [configurationDictionary objectForKey:@"Socialize API info"];
}

+ (void)enableValidFacebookSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *apiInfo = [self authInfoFromConfig];
    if ([apiInfo objectForKey:@"facebookToken"]) {
        [defaults setObject:[apiInfo objectForKey:@"facebookToken"] forKey:@"FBAccessTokenKey"];
        [defaults setObject:[NSDate distantFuture] forKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

+ (void)disableValidFacebookSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

+ (NSString*)runID {
    if (TestAppKIFTestControllerRunID == nil) {
        NSString *uuid = UUIDString();
        NSString *sha1 = [uuid sha1];
        NSString *runID = [sha1 substringToIndex:8];
        
        TestAppKIFTestControllerRunID = runID;
    }
    
    return TestAppKIFTestControllerRunID;
}

+ (NSString*)testURL:(NSString*)suffix {
    return [NSString stringWithFormat:@"http://itest.%@/%@", [self runID], suffix];
}
@end
