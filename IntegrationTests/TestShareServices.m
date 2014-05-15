//
//  TestShareServices.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestShareServices.h"
#import <Loopy/Loopy.h>
#import <AFNetworking/AFNetworking.h>

@implementation TestShareServices

- (void)testCreateShare {
    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", sel_getName(_cmd)]];
    [self createShareWithURL:shareURL medium:SocializeShareMediumFacebook text:@"a share"];
}

- (void)testCreateShareWithPropagationInfo {
    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", sel_getName(_cmd)]];
    SocializeEntity *entity = [SocializeEntity entityWithKey:shareURL name:@"Test"];
    SocializeShare *share = [SocializeShare shareWithEntity:entity text:@"a share" medium:SocializeShareMediumFacebook];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"facebook"] forKey:@"third_parties"]];
    [self createShare:share];
    
    // verify share
    id<SocializeShare> createdShare = self.createdObject;
    NSDictionary *facebookResponse = [[createdShare propagationInfoResponse] objectForKey:@"facebook"];
    GHAssertNotNil([facebookResponse objectForKey:@"application_url"], nil);
    GHAssertNotNil([facebookResponse objectForKey:@"entity_url"], nil);
}

- (void)testCreateShareWithLoopyVerification {
    __block BOOL operationSucceeded = NO;
    //TODO LOOPY CALLBACKS DO NOT WORK WITH GHUNIT WHEN NOT TYPED
//    __block TestShareServices *blockSafeSelf = self;
    [self prepare];
    NSString *shareURL = @"http://www.sharethis.com";
    SocializeEntity *entity = [SocializeEntity entityWithKey:shareURL name:@"Test"];
    SocializeShare *share = [SocializeShare shareWithEntity:entity text:@"a share" medium:SocializeShareMediumFacebook];
    
    //loopy callbacks
    void(^loopySuccessCallback)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"********************************testCreateShareWithLoopyVerification:SUCCESS!!!");
//            [blockSafeSelf notify:kGHUnitWaitStatusSuccess forSelector:@selector(testCreateShareWithLoopyVerification)];
//            operationSucceeded = YES;
    };
    void(^loopyFailureCallback)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"********************************testCreateShareWithLoopyVerification:FAILURE!!!");
//        [blockSafeSelf notify:kGHUnitWaitStatusFailure forSelector:@selector(testCreateShareWithLoopyVerification)];
//        operationSucceeded = NO;
    };
    
    [self createShare:share
              success:^(id<SocializeShare> share) {
                  [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testCreateShareWithLoopyVerification)];
                  operationSucceeded = YES;
              }
              failure:^(NSError *error) {
                  [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testCreateShareWithLoopyVerification)];
                  operationSucceeded = NO;
              }
         loopySuccess:loopySuccessCallback
         loopyFailure:loopyFailureCallback];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
    GHAssertTrue(operationSucceeded, @"");
//    [self prepare];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
//    GHAssertTrue(operationSucceeded, @"");
}

@end
