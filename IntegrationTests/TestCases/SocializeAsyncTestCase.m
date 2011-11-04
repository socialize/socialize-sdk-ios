//
//  SocializeTestCase.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeAsyncTestCase.h"

@implementation SocializeAsyncTestCase

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)waitForStatus:(NSInteger)status {
    [self prepare];
    [self waitForStatus:status timeout:5.0];
}
@end
