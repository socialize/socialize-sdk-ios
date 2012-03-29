//
//  SocializeDirectEntityNotificationDisplayControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeDirectEntityNotificationDisplayControllerTests.h"
#import "_Socialize.h"

@implementation SocializeDirectEntityNotificationDisplayControllerTests
@synthesize directEntityNotificationDisplayController = directEntityNotificationDisplayController_;
@synthesize mockSocialize = mockSocialize_;

- (id)createUUT {
    self.directEntityNotificationDisplayController = [[[SocializeDirectEntityNotificationDisplayController alloc] initWithUserInfo:nil] autorelease];

    return self.directEntityNotificationDisplayController;
}

- (void)setUp {
    [super setUp];
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    self.directEntityNotificationDisplayController.socialize = self.mockSocialize;
}

- (void)tearDown {
    [self.mockSocialize verify];
    
    self.directEntityNotificationDisplayController = nil;
    
    [super tearDown];
}

- (void)testMainViewControllerNotNil {
    UIViewController *mainViewController = [self.directEntityNotificationDisplayController mainViewController];
    GHAssertNotNil(mainViewController, @"view controller not defined");
}

- (void)succeedFetchingEntityWithMock:(id)mockEntity {
    [[[self.mockSocialize expect] andDo1:^(NSNumber* entityId) {
        [self.directEntityNotificationDisplayController service:nil didFetchElements:[NSArray arrayWithObject:mockEntity]];
    }] getEntityWithId:OCMOCK_ANY];
}

- (void)setValidUserInfo {
    NSDictionary *socializeInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:123] forKey:@"entity_id"];
    self.directEntityNotificationDisplayController.userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
}

- (void)expectDismiss {
    [[self.mockDelegate expect] notificationDisplayControllerDidFinish:self.notificationDisplayController];
}

- (void)testSuccessfulFetch {
    [self setValidUserInfo];
    
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [self succeedFetchingEntityWithMock:mockEntity];
    
    [Socialize setEntityLoaderBlock:^(UINavigationController *nav, id<SocializeEntity> entity) {
        [self notify:kGHUnitWaitStatusSuccess];
    }];
    
    [self prepare];
    [self.directEntityNotificationDisplayController viewWasAdded];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
    
    [self expectDismiss];
    [self.directEntityNotificationDisplayController navigationController:nil willShowViewController:(UIViewController*)self.directEntityNotificationDisplayController.dummyController animated:YES];
}

- (void)testServiceFailureCausesDismiss {
    [self expectDismiss];
    
    [self.directEntityNotificationDisplayController service:nil didFail:nil];
}


@end
