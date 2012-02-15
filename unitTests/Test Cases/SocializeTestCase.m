//
//  SocializeTestCase.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTestCase.h"
#import "UIAlertView+Observer.h"

@implementation SocializeTestCase
@synthesize lastShownAlert = lastReceivedAlert_;

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertShown:) name:UIAlertViewDidShowNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)alertShown:(NSNotification*)notification {
    self.lastShownAlert = [notification object];
}

@end
