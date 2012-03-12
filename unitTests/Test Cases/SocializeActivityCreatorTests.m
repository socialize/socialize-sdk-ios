//
//  SocializeActivityCreatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityCreatorTests.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "NSError+Socialize.h"
#import "SocializeFacebookWallPoster.h"
#import "SocializePrivateDefinitions.h"

@implementation SocializeActivityCreatorTests
@synthesize mockActivity = mockActivity_;
@synthesize activityCreator = activityCreator_;
@synthesize mockOptions = mockOptions_;
@synthesize lastError = lastError_;

- (id)createAction {
    __block id weakSelf = self;
    
    self.mockOptions = [OCMockObject niceMockForClass:[SocializeActivityOptions class]];
    self.mockActivity = [OCMockObject niceMockForProtocol:@protocol(SocializeActivity)];
    self.activityCreator = [[[SocializeActivityCreator alloc]
                             initWithActivity:self.mockActivity
                             options:self.mockOptions
                             displayProxy:nil
                             display:self.mockDisplay] autorelease];
    
    self.activityCreator.activitySuccessBlock = ^(id<SocializeActivity> activity) {
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    self.activityCreator.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
        self.lastError = error;
    };
    
    return self.activityCreator;
}

- (void)setUp {
    [super setUp];
    
    [SocializeThirdPartyFacebook startMockingClass];
    [SocializeThirdPartyTwitter startMockingClass];
    [SocializeFacebookWallPoster startMockingClass];
    [[[SocializeThirdPartyTwitter stub] andReturn:@"Twitter"] thirdPartyName];
    [[[SocializeThirdPartyFacebook stub] andReturn:@"Facebook"] thirdPartyName];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY];
}

- (void)tearDown {
    [self.mockActivity verify];
    [self.mockOptions verify];
    
    [SocializeThirdPartyTwitter stopMockingClassAndVerify];
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];
    [SocializeFacebookWallPoster stopMockingClassAndVerify];
    self.mockActivity = nil;
    self.mockOptions = nil;
    self.activityCreator = nil;

    [super tearDown];
}

- (void)expectNotLinkedFailure {
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
    GHAssertTrue([self.lastError isSocializeErrorWithCode:SocializeErrorThirdPartyNotLinked], @"unexpected error");
}

- (void)testAttemptingTwitterWhenTwitterNotLinkedCausesFailure {
    [[[self.mockOptions stub] andReturn:[NSArray arrayWithObject:@"twitter"]] thirdParties];
    [[[SocializeThirdPartyTwitter stub] andReturnBool:NO] isLinkedToSocialize];
    
    [self expectNotLinkedFailure];
}

- (void)testAttemptingFacebookWhenFacebookNotLinkedCausesFailure {
    [[[self.mockOptions stub] andReturn:[NSArray arrayWithObject:@"facebook"]] thirdParties];
    [[[SocializeThirdPartyFacebook stub] andReturnBool:NO] isLinkedToSocialize];
    
    [self expectNotLinkedFailure];
}

- (void)succeedSocializeCreate {
    [[[(id)self.partialAction expect] andDo0:^{
        [self.activityCreator succeedServerCreateWithActivity:self.mockActivity];
    }] createActivityOnSocializeServer];
}

- (void)expectSetTwitterInActivity:(id)mockActivity {
    [[[mockActivity expect] andDo1:^(NSArray *thirdParties) {
        NSArray *expectedThirdParties = [NSArray arrayWithObject:@"twitter"];
        GHAssertEqualObjects(thirdParties, expectedThirdParties, @"bad third parties %@", thirdParties);
    }] setThirdParties:OCMOCK_ANY];
}

- (void)rejectSetTwitterInActivity:(id)mockActivity {
    [[mockActivity reject] setThirdParties:OCMOCK_ANY];
}

- (void)selectJustTwitterInOptions {
    [[[SocializeThirdPartyTwitter stub] andReturnBool:YES] isLinkedToSocialize];
    
    // Explicitly Specify twitter in options
    [[[self.mockOptions stub] andReturn:[NSArray arrayWithObject:@"twitter"]] thirdParties];
}

- (void)selectJustFacebookInOptions {
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] isLinkedToSocialize];
    
    // Explicitly Specify twitter in options
    [[[self.mockOptions stub] andReturn:[NSArray arrayWithObject:@"facebook"]] thirdParties];
}

- (void)testSuccessfulSocializeCreateWithJustTwitterSucceeds {
    [self selectJustTwitterInOptions];
    
    [self succeedSocializeCreate];
    [self expectSetTwitterInActivity:self.mockActivity];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testSuccessfulSocializeCreateWithJustTwitterSucceedsAndDoesNotAutopostIfDisabled {
    [self selectJustTwitterInOptions];
    
    [self succeedSocializeCreate];

    // User turned off twitter autopost
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY];
    [self rejectSetTwitterInActivity:self.mockActivity];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testSuccessfulSocializeCreateWithJustTwitterSucceedsNoOptions {
    // Twitter linked and selected
    [[[SocializeThirdPartyTwitter stub] andReturnBool:YES] isLinkedToSocialize];
    [[[SocializeThirdPartyFacebook stub] andReturnBool:NO] isLinkedToSocialize];
    
    [self succeedSocializeCreate];
    [self expectSetTwitterInActivity:self.mockActivity];

    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)succeedFacebookWallPost {
    [[[SocializeFacebookWallPoster expect] andDo4:^(id options, id displayProxy, id success, id failure) {
        void (^successBlock)() = success;
        successBlock();
    }] postToFacebookWallWithOptions:OCMOCK_ANY displayProxy:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
}

- (void)testSuccessfulSocializeCreateWithFacebookPostsToWallAndSucceeds {
    // Facebook linked and selected
    [self selectJustFacebookInOptions];
    
    [[[(id)self.partialAction stub] andReturn:@"Let's get Social, already"] textForFacebook];
    
    [self succeedSocializeCreate];
    [self succeedFacebookWallPost];
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}


@end
