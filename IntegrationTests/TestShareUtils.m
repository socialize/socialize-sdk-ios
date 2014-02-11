//
//  TestSZShareUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestShareUtils.h"
#import <Socialize/Socialize.h>
#import "integrationtests_globals.h"

@interface TestShareUtils() {
    id loopySDK;
}

@end
@implementation TestShareUtils

- (void)setUpClass {
    //cannot be tested headlessly until import issues resolved to allow proper mocking
//    loopySDK = [SZShareUtils sharedLoopySDK];
}

- (id<SZShare>)createTestShareForSelector:(SEL)selector {
    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", sel_getName(selector)]];
    SZEntity *entity = [SZEntity entityWithKey:shareURL name:@"Share"];
    
    SZShare *share = [SZShare shareWithEntity:entity text:@"some text" medium:SocializeShareMediumSMS];
    [self createShare:share];
    id<SZShare> createdShare = [[self.createdObject retain] autorelease];

    return createdShare;
}

- (void)testGetSharesByIds {
    NSString *shareURL = [self testURL:[NSString stringWithFormat:@"%s/share", sel_getName(_cmd)]];
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
    id<SZShare> createdShare = [self createTestShareForSelector:_cmd];
    
    [self prepare];
    [SZShareUtils getSharesWithEntity:createdShare.entity
                                first:nil
                                 last:nil
                              success:^(NSArray *shares) {
                                  id<SZShare> fetchedShare1 = [shares objectAtIndex:0];
                                  
                                  GHAssertEquals([fetchedShare1 objectID], [createdShare objectID], @"Bad id");
                                  
                                  [self notify:kGHUnitWaitStatusSuccess];
                                  
                              } failure:^(NSError *error) {
                                  [self notify:kGHUnitWaitStatusFailure];
                              }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)testGetSharesByUser {
    id<SZShare> createdShare = [self createTestShareForSelector:_cmd];
    
    [self prepare];
    [SZShareUtils getSharesWithUser:[[Socialize sharedSocialize] authenticatedUser]
                                first:nil
                                 last:[NSNumber numberWithInt:1]
                              success:^(NSArray *shares) {
                                  id<SZShare> fetchedShare1 = [shares objectAtIndex:0];
                                  
                                  GHAssertTrue([shares count] == 1, @"Bad count %d", [shares count]);
                                  GHAssertEquals([fetchedShare1 objectID], [createdShare objectID], @"Bad id");
                                  GHAssertTrue([fetchedShare1 conformsToProtocol:@protocol(SocializeShare)], @"Bad protocol");
                                  
                                  [self notify:kGHUnitWaitStatusSuccess];
                                  
                              } failure:^(NSError *error) {
                                  [self notify:kGHUnitWaitStatusFailure];
                              }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)testGetSharesByUserAndEntity {
    id<SZShare> createdShare = [self createTestShareForSelector:_cmd];
    
    [self prepare];
    [SZShareUtils getSharesWithUser:[[Socialize sharedSocialize] authenticatedUser]
                             entity:createdShare.entity
                              first:nil
                               last:nil
                            success:^(NSArray *shares) {
                                id<SZShare> fetchedShare = [shares objectAtIndex:0];
                                
                                GHAssertTrue([shares count] == 1, @"Expected 1 share but found %d", [shares count]);
                                GHAssertEquals([fetchedShare objectID], [createdShare objectID], @"Bad id");
                                GHAssertTrue([fetchedShare conformsToProtocol:@protocol(SocializeShare)], @"Bad protocol");

                                [self notify:kGHUnitWaitStatusSuccess];
                                
                            } failure:^(NSError *error) {
                                [self notify:kGHUnitWaitStatusFailure];
                            }];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)testGetSharesByApplication {
    id<SZShare> createdShare = [self createTestShareForSelector:_cmd];

    // Fetch by user and entity
    NSArray *fetchedShares = [self getSharesByApplication];
    id<SZComment> fetchedComment = [fetchedShares bk_match:^BOOL (id<SZShare> share) {
        return [share objectID] == [createdShare objectID];
    }];
    GHAssertNotNil(fetchedComment, @"Comment not on user");
}

//Uncomment once integration complete
//- (void)testReportShareToLoopy {
//    [self prepare];
//    __block BOOL operationSucceeded = NO;
//    [SZShareUtils reportShareToLoopyWithText:@"test text"
//                                     channel:@"facebook"
//                                     success:^(id operation, id responseObject) {
//                                         NSDictionary *responseDict = (NSDictionary *)responseObject;
//                                         if([responseDict count] == 0) {
//                                             operationSucceeded = YES;
//                                             [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testReportShareToLoopy)];
//                                         }
//                                         else {
//                                             operationSucceeded = NO;
//                                             [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testReportShareToLoopy)];
//                                         }
//                                     }
//                                     failure:^(id operation, NSError *error) {
//                                         operationSucceeded = NO;
//                                         [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testReportShareToLoopy)];
//                                     }];
//    
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
//    GHAssertTrue(operationSucceeded, @"");
//}

@end
