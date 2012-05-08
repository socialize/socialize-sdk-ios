//
//  TestSZShareUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestSZShareUtils.h"
#import "SZShareUtils.h"

@implementation TestSZShareUtils

- (void)testGetSharesByIds {
    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", _cmd]];
    SZEntity *entity = [SZEntity entityWithKey:shareURL name:@"Share"];
    
    SZShare *share1 = [SZShare shareWithEntity:entity text:@"some text" medium:SocializeShareMediumSMS];
    [self createShare:share1];
    id<SZShare> createdShare1 = [[self.createdObject retain] autorelease];

    SZShare *share2 = [SZShare shareWithEntity:entity text:@"some text" medium:SocializeShareMediumEmail];
    [self createShare:share2];
    id<SZShare> createdShare2 = [[self.createdObject retain] autorelease];

    NSArray *idsOut = [NSArray arrayWithObjects:[NSNumber numberWithInteger:createdShare1.objectID], [NSNumber numberWithInteger:createdShare2.objectID], nil];
    
    [self prepare];
    [SZShareUtils getSharesWithIds:idsOut
                           success:^(NSArray *shares) {
                               id<SZShare> fetchedShare1 = [shares objectAtIndex:0];
                               id<SZShare> fetchedShare2 = [shares objectAtIndex:1];
                               NSArray *idsReturned = [NSArray arrayWithObjects:[NSNumber numberWithInteger:fetchedShare1.objectID], [NSNumber numberWithInteger:fetchedShare2.objectID], nil];
                               
                               NSSet *outSet = [NSSet setWithArray:idsOut];
                               NSSet *returnedSet = [NSSet setWithArray:idsReturned];
                               
                               GHAssertEqualObjects(outSet, returnedSet, @"Ids did not match");
                               
                               [self notify:kGHUnitWaitStatusSuccess];

                           } failure:^(NSError *error) {
                               [self notify:kGHUnitWaitStatusFailure];
                           }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)testGetSharesByEntity {
    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", _cmd]];
    SZEntity *entity = [SZEntity entityWithKey:shareURL name:@"Share"];
    
    SZShare *share1 = [SZShare shareWithEntity:entity text:@"some text" medium:SocializeShareMediumSMS];
    [self createShare:share1];
    id<SZShare> createdShare1 = [[self.createdObject retain] autorelease];
    
    [self prepare];
    [SZShareUtils getSharesWithEntity:entity
                                first:nil
                                 last:nil
                              success:^(NSArray *shares) {
                                  id<SZShare> fetchedShare1 = [shares objectAtIndex:0];
                                  
                                  GHAssertEquals([fetchedShare1 objectID], [createdShare1 objectID], @"Bad id");
                                  
                                  [self notify:kGHUnitWaitStatusSuccess];
                                  
                              } failure:^(NSError *error) {
                                  [self notify:kGHUnitWaitStatusFailure];
                              }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}


@end
