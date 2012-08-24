//
//  ui_advanced.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "ui_advanced.h"
#import <Socialize/Socialize.h>

@implementation ui_advanced

// begin-disable-location-snippet

- (void)disableLocationSharing {
    [Socialize storeLocationSharingDisabled:YES];
}

// end-disable-location-snippet
@end
