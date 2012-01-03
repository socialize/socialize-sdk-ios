//
//  ActivityDetailsViewTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 1/2/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "ActivityDetailsViewTests.h"
#import "HtmlPageCreator.h"

@implementation ActivityDetailsViewTests

@synthesize activityDetailsView = activityDetailsView_;
@synthesize partialActivityDetailsView = partialActivitydetailsView_;
@synthesize mockHtmlCreator = mockHtmlCreator_;
@synthesize mockActivityMessageView = mockActivityMessageView_;

-(void)setUp {
    self.activityDetailsView = [[SocializeActivityDetailsView alloc] init];
    self.partialActivityDetailsView = [OCMockObject partialMockForObject:self.activityDetailsView];
    
    //create/assign the mock html creator to the real object
    self.mockHtmlCreator = [OCMockObject mockForClass:[HtmlPageCreator class]];
    self.activityDetailsView.htmlPageCreator = self.mockHtmlCreator;
    
    //we need to assign this view to the details view property
    self.mockActivityMessageView  = [OCMockObject mockForClass:[UIWebView  class]];
    self.activityDetailsView.activityMessageView = self.mockActivityMessageView;
    
}

-(void)tearDown {
    [self.partialActivityDetailsView verify];
    [self.mockHtmlCreator verify];
    [self.mockActivityMessageView verify];
    
    self.activityDetailsView = nil;
    self.partialActivityDetailsView = nil;
    self.mockHtmlCreator = nil;
    self.mockActivityMessageView = nil;
}

-(void) testUpdateActivityMessage {
    //expect that the load template is called
    [[self.mockHtmlCreator expect] loadTemplate:OCMOCK_ANY];
    [[self.mockHtmlCreator expect] addInformation:OCMOCK_ANY forTag:@"DATE_TEXT"];
    [[self.mockHtmlCreator expect] addInformation:OCMOCK_ANY forTag:@"COMMENT_TEXT"];
    
    NSString* sampleHTML = @"<bold>test</bold>";
    [[[self.mockHtmlCreator expect] andReturn:sampleHTML] html];
    [[self.mockActivityMessageView expect] loadHTMLString:sampleHTML baseURL:nil];

    //this is added so that there is a valid string
    self.activityDetailsView.activityMessage = @"test string";

    [self.activityDetailsView updateActivityMessageView];
}

-(void)testWebViewDidFinish {
    [[self.partialActivityDetailsView expect] layoutActivityDetailsSubviews];
    [self.activityDetailsView webViewDidFinishLoad:self.mockActivityMessageView];
}

@end
