//
//  SocializeActionTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeActionTests.h"
#import "_Socialize.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeFacebookAuthenticator.h"
#import "SocializeFacebookWallPoster.h"


@interface FailingAction : SocializeAction
@end

@implementation FailingAction
- (void)executeAction {
    NSError *error = [[[NSError alloc] init] autorelease];
    [self failWithError:error];
}
@end

@interface SucceedingAction : SocializeAction
@end

@implementation SucceedingAction
- (void)executeAction {
    [self succeed];
}
@end

@interface DisplayImplementation : NSObject
@end

@implementation DisplayImplementation
- (void)socializeObject:(id)object requiresDisplayOfActionSheet:(UIActionSheet*)actionSheet {}
- (void)socializeObject:(id)object requiresDisplayOfViewController:(UIViewController *)controller {}
- (void)socializeObject:(id)object requiresDismissOfViewController:(UIViewController *)controller {}
- (void)socializeObject:(id)object requiresDisplayOfAlertView:(UIAlertView *)alertView {}
- (void)socializeObjectWillStartLoading:(id)object {}
- (void)socializeObjectWillStopLoading:(id)object {}
@end

@implementation SocializeActionTests
@synthesize action = action_;
@synthesize partialAction = partialAction_;
@synthesize mockDisplay = display_;
@synthesize mockSocialize = mockSocialize_;

- (id)createAction {
    __block id weakSelf = self;

    SocializeAction *action = [[[SocializeAction alloc] initWithOptions:nil display:self.mockDisplay] autorelease];
    action.successBlock = ^{
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    action.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
    };
    
    return action;

}

- (void)setUp {
    self.mockDisplay = [OCMockObject mockForClass:[DisplayImplementation class]];
    [[[self.mockDisplay stub] andReturnBool:NO] isKindOfClass:[UITabBarController class]];
    
    self.action = [self createAction];
//    [self expectDeallocationOfObject:self.action fromTest:self.currentSelector];

    self.partialAction = [OCMockObject partialMockForObject:self.action];
    
    self.mockSocialize = [OCMockObject mockForClass:[Socialize class]];
    [[self.mockSocialize stub] setDelegate:nil];
    
    self.action.socialize = self.mockSocialize;
}

- (void)tearDown {
    [self.mockDisplay verify];
    self.mockDisplay = nil;
    self.partialAction = nil;
    self.action.socialize = nil;
    self.action = nil;
    
    [super tearDown];
}

- (void)succeedFacebookAuthentication {
    
    // Initially, not authenticated
    [[[self.mockSocialize expect] andReturnBool:NO] isAuthenticatedWithFacebook];
    
    [[[SocializeFacebookAuthenticator expect] andDo4:^(id options, id display, id success, id failure) {
        // Succeed -- Authenticated from now on
        [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticatedWithFacebook];
        
        void (^successBlock)() = success;
        successBlock();
    }] authenticateViaFacebookWithOptions:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)failFacebookAuthentication {
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticatedWithFacebook];
    [[[SocializeFacebookAuthenticator expect] andDo4:^(id options, id display, id success, id failure) {
        void (^failureBlock)(NSError *error) = failure;
        failureBlock(nil);
    }] authenticateViaFacebookWithOptions:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)failTwitterAuthentication {
    [[[self.mockSocialize stub] andReturnBool:NO] isAuthenticatedWithTwitter];
    [[[SocializeTwitterAuthenticator expect] andDo4:^(id options, id display, id success, id failure) {
        void (^failureBlock)(NSError *error) = failure;
        failureBlock(nil);
    }] authenticateViaTwitterWithOptions:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)succeedTwitterAuthentication {
    
    // Initially, not authenticated
    [[[self.mockSocialize expect] andReturnBool:NO] isAuthenticatedWithTwitter];
    
    [[[SocializeTwitterAuthenticator expect] andDo4:^(id options, id display, id success, id failure) {
        // Succeed -- Authenticated from now on
        [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticatedWithTwitter];
        
        void (^successBlock)() = success;
        successBlock();
    }] authenticateViaTwitterWithOptions:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}


- (void)succeedPostingToFacebookWall {
    [[[SocializeFacebookWallPoster expect] andDo4:^(id options, id display, id success, id failure) {
        // Succeed -- Authenticated from now on
        [[[self.mockSocialize stub] andReturnBool:YES] isAuthenticatedWithFacebook];
        
        void (^successBlock)() = success;
        successBlock();
    }] postToFacebookWallWithOptions:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)executeAction:(SocializeAction*)action andWaitForStatus:(int)status {
    [self prepare];
    [SocializeAction executeAction:action];
    [self waitForStatus:status timeout:1.0];
    
    [action waitUntilFinished];
}

- (void)executeActionAndWaitForStatus:(int)status fromTest:(SEL)test {
    [self prepare];
    [SocializeAction executeAction:self.action];
    [self waitForStatus:status timeout:1.0];
    
    [self expectDeallocationOfObject:self.action fromTest:test];
    
    [self.action waitUntilFinished];
}

- (void)testFailingAction {
    FailingAction *fail = [[[FailingAction alloc] initWithOptions:nil display:nil] autorelease];
    fail.failureBlock = ^(NSError *error) { 
        [self notify:kGHUnitWaitStatusFailure];
    };
    
    [self executeAction:fail andWaitForStatus:kGHUnitWaitStatusFailure];
}

- (void)testSucceedingAction {
    SucceedingAction *succeed = [[[SucceedingAction alloc] initWithOptions:nil display:nil] autorelease];
    succeed.successBlock = ^{
        [self notify:kGHUnitWaitStatusSuccess];
    };

    [self executeAction:succeed andWaitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)testCancellingCallbacks {
    [self.action cancelAllCallbacks];
}

- (void)testDefaultAction {
    [SocializeAction executeAction:self.action];
}

@end
