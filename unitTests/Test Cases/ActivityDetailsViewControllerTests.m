//
//  ActivityDetailsViewControllerTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "ActivityDetailsViewControllerTests.h"

#import <OCMock/OCMock.h>

@implementation ActivityDetailsViewControllerTests

@synthesize mockActivityDetailsView = mockActivityDetailsView_;
@synthesize mockSocializeActivity = mockSocializeActivity_;
@synthesize mockProfileImageDownloader =mockProfileImageDownloader_ ;
@synthesize mockCache = mockCache_;
@synthesize mockActivityViewController = mockActivityViewController_;

-(void)setUp 
{
    self.mockActivityDetailsView = [OCMockObject mockForClass:[SocializeActivityDetailsView class]];
 /*
    self.mockSocializeActivity = [OCMockObject mockForClass:[SocializeActivityDetailsView class]]; <SocializeActivity> socializeActivity;
    self.mockProfileImageDownloader = [OCMockObject mockForClass:[URLDownload class]];
    
 [OCMockObject mockForClass:[SocializeActivityDetailsView class]]; ImagesCache*  cache;
[OCMockObject mockForClass:[SocializeActivityDetailsView class]];SocializeActivityViewController*  activityViewController;*/
    
}

-(void) testProfileButtonTapped {
    /*
    [[[self.partialMockCommentDetailsViewController expect] andReturn:self.mockProfileNavigationController] getProfileViewControllerForUser:OCMOCK_ANY];
    [[[self.partialMockCommentDetailsViewController expect] andReturn:OCMOCK_ANY] createLeftNavigationButtonWithCaption:OCMOCK_ANY];
    
    //setup mock navigation controller
    [[[self.partialMockCommentDetailsViewController expect] andReturn:self.mockNavigationController] navigationController];
    [[self.mockNavigationController expect] pushViewController:self.mockProfileNavigationController animated:YES];
    
    id mockSender = [OCMockObject mockForClass:[UIButton class]];
    [commentDetails profileButtonTapped:mockSender];
     */
}


@end
