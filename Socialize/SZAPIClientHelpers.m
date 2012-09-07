//
//  SZAPIClientHelpers.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/13/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZAPIClientHelpers.h"
#import "socialize_globals.h"
#import "SocializePrivateDefinitions.h"
#import "SocializeObjectFactory.h"
#import "NSData+Base64.h"

void SZHandleUserChange(id<SZFullUser> fullUser) {
    NSDictionary *fullUserDictionary = [fullUser serverDictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:fullUserDictionary];
        [userDefaults setObject:data forKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
        [userDefaults synchronize];
    }
    
    // Post a global notification that the authenticated user has changed
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:fullUser];
}

id SZUnarchiveUser(Protocol* protocol) {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    if (userData != nil) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return [[SocializeObjectFactory sharedObjectFactory] createObjectFromDictionary:info forProtocol:protocol];
    }
    // Not available
    return nil;
}

NSString *SZAPINSStringFromSZResultSorting(SZResultSorting sorting) {
    switch (sorting) {
        case SZResultSortingMostRecent:
            return nil;
        case SZResultSortingPopularity:
            return @"total_activity";
            
    }
    
    return nil;
}

void SZPostActivityEntityDidChangeNotifications(NSArray *activities) {
    NSMutableSet *entities = [NSMutableSet set];
    for (id<SZActivity> activity in activities) {
        [entities addObject:activity.entity];
    }
    
    for (id<SZEntity> entity in entities) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SZEntityDidChangeNotification object:entity];
    }
}

NSString *SZGetProvisioningProfile() {
    NSString * profilePath = [[NSBundle mainBundle] pathForResource:@"embedded.mobileprovision" ofType:nil];
    if (profilePath == nil) {
        return nil;
    }
    
    NSData *profileData = [NSData dataWithContentsOfFile:profilePath];
    NSData *startData = [@"<!DOCTYPE" dataUsingEncoding:NSISOLatin1StringEncoding];
    
    // Find the xml string
    NSRange doctypeRange = [profileData rangeOfData:startData options:0 range:NSMakeRange(0, [profileData length])];
    if (doctypeRange.location == NSNotFound) {
        return nil;
    }
    NSRange xmlRange = NSMakeRange(doctypeRange.location, [profileData length] - doctypeRange.location);
    NSData *xmlData = [profileData subdataWithRange:xmlRange];
    NSString *profileAsString = [[NSString alloc] initWithData:xmlData encoding:NSISOLatin1StringEncoding];
    
    return profileAsString;
}

BOOL SZIsProduction() {
    NSString *profileAsString = SZGetProvisioningProfile();
    if ([profileAsString length] == 0) {
        return NO;
    }
    
    profileAsString = [[profileAsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    NSRange range = [profileAsString rangeOfString:@"<key>get-task-allow</key><true/>" options:NSCaseInsensitiveSearch];
    BOOL isProduction = range.location == NSNotFound;
    
    return isProduction;
}


NSString *SZAPINSStringForCurrentProvisioningState() {
    if (SZIsProduction()) {
        return @"APNS_PRODUCTION";
    } else {
        return @"APNS_DEVELOPMENT";
    }
}

NSString *SZBase64EncodedUDID() {
    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
    NSData *udidData = [udid dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [udidData base64Encoding];
    return encoded;
}

BOOL SZEventTrackingDisabled() {
    const char *disabled = getenv("SZEventTrackingDisabled");
    if (disabled != NULL && strncmp("1", disabled, 1) == 0) {
        return YES;
    }
    
    return NO;
}