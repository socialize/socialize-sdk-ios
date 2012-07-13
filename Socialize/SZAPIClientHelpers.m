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
