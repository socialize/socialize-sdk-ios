//
//  SZAPIEventListener.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/5/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZAPIEventListener.h"
#import "SocializeCommonDefinitions.h"
#import "_Socialize.h"

static SZAPIEventListener *sharedAPIEventListener;

@implementation SZAPIEventListener

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

+ (SZAPIEventListener*)sharedAPIEventListener {
    if (sharedAPIEventListener == nil) {
        
    }
    
    return sharedAPIEventListener;
}

+ (void)load {
#ifndef SZ_SINGLETONS_DISABLED
    (void)[self sharedAPIEventListener];
#endif
}

//- (id)init {
//    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailWithErrorNotification:) name:SZDidFailWithErrorNotification object:nil];
//    }
//}
//
//- (void)didFailWithErrorNotification:(NSNotification*)notification {
//    if ([[error domain] isEqualToString:SocializeErrorDomain] && [error code] == SocializeErrorServerReturnedHTTPError) {
//        NSHTTPURLResponse *response = [[error userInfo] objectForKey:kSocializeErrorNSHTTPURLResponseKey];
//        if ([response statusCode] == 401) {
//            [self.socialize removeSocializeAuthenticationInfo];
//        }
//    }
//}
         
@end
