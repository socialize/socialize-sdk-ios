//
//  UserHelper.m
//  Socialize
//
//  Created by David Jedeikin on 8/29/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "UserHelper.h"

@implementation UserHelper

//Returns display name given userName, firstName, lastName
+ (NSString*)getDisplayName:(NSString*)userName firstName:(NSString *)firstName lastName:(NSString*)lastName {
    NSString* retVal = userName;
    if(firstName && [firstName length] > 0 && lastName && [lastName length] > 0) {
        retVal = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    }
    else if(firstName && [firstName length] > 0) {
        retVal = firstName;
    }
    else if(lastName && [lastName length] > 0) {
        retVal = lastName;
    }
    
    return retVal;
}

@end
