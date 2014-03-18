//
//  SZAPIClientHelpers.h
//  Socialize
//
//  Created by Nathaniel Griswold on 7/13/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

extern id SZUnarchiveUser(Protocol* protocol);
extern void SZHandleUserChange(id<SZFullUser> fullUser);
extern NSString *SZAPINSStringFromSZResultSorting(SZResultSorting sorting);
extern BOOL SZUseProductionPush();
extern void SZPostActivityEntityDidChangeNotifications(NSArray *activities);
extern BOOL SZEventTrackingDisabled();