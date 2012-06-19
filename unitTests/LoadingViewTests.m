//
//  LoadingViewTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/28/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "LoadingViewTests.h"
#import "OCMock/OCMock.h"
#import "SocializeLoadingView.h"

@implementation LoadingViewTests

- (void)testLoadingViewClassHelper {
    UIView *testView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    SocializeLoadingView *loadingView = [SocializeLoadingView loadingViewInView:testView];
    GHAssertEquals(loadingView.superview, testView, nil);
    GHAssertTrue(CGRectEqualToRect(loadingView.frame, CGRectMake(0, 0, 320, 460)), nil);
}

- (void)testOtherLoadingViewClassHelper {
    UIView *testView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    CGRect testRect = CGRectMake(10, 10, 50, 50);
    SocializeLoadingView *loadingView = [SocializeLoadingView loadingViewInView:testView withFrame:testRect andString:@"blah"];
    GHAssertEquals(loadingView.superview, testView, nil);
    GHAssertTrue(CGRectEqualToRect(loadingView.frame, testRect), nil);
}

@end
