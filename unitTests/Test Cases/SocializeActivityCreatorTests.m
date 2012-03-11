//
//  SocializeActivityCreatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityCreatorTests.h"

@implementation SocializeActivityCreatorTests
@synthesize mockActivity = mockActivity_;
@synthesize activityCreator = activityCreator_;
@synthesize mockOptions = mockOptions_;

- (id)createAction {
    __block id weakSelf = self;
    
    self.mockOptions = [OCMockObject niceMockForClass:[SocializeActivityOptions class]];
    self.mockActivity = [OCMockObject mockForProtocol:@protocol(SocializeActivity)];
    self.activityCreator = [[[SocializeActivityCreator alloc]
                             initWithActivity:self.mockActivity
                             options:self.mockOptions
                             displayProxy:nil
                             display:self.mockDisplay] autorelease];
    
    self.activityCreator.successBlock = ^{
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    self.activityCreator.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
    };
    
    return self.activityCreator;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [self.mockActivity verify];
    [self.mockOptions verify];
    
    self.mockActivity = nil;
    self.mockOptions = nil;
    self.activityCreator = nil;
}

@end
