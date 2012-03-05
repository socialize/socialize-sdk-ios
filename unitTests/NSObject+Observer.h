//
//  NSObject+Observer.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NSObjectClassDidDeallocateNotification;
extern NSString *const NSObjectDeallocatedAddressKey;

@interface NSObject (Observer)
+ (void)startObservingDeallocationsForClass:(Class)class;

@end
