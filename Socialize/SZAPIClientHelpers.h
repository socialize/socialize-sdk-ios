//
//  SZAPIClientHelpers.h
//  Socialize
//
//  Created by Nathaniel Griswold on 7/13/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

id SZUnarchiveUser(Protocol* protocol);
void SZHandleUserChange(id<SZFullUser> fullUser);
NSString *SZAPINSStringFromSZResultSorting(SZResultSorting sorting);
BOOL SZUseProductionPush();
void SZPostActivityEntityDidChangeNotifications(NSArray *activities);
NSString *SZBase64EncodedUDID();
BOOL SZEventTrackingDisabled();