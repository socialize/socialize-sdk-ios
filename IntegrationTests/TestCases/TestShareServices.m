//
//  TestShareServices.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestShareServices.h"

@implementation TestShareServices

- (void)testCreateShare {
    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", _cmd]];
    [self createShareWithURL:shareURL medium:SocializeShareMediumFacebook text:@"a share"];
}

@end
