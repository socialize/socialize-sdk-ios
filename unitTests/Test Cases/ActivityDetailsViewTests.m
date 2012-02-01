//
//  ActivityDetailsViewTests.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 1/2/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "ActivityDetailsViewTests.h"
#import "HtmlPageCreator.h"
#import "UIButton+Socialize.h"
#import "_Socialize.h"
#import "UIView+Layout.h"

@interface SocializeActivityDetailsView ()
-(CGFloat)getMessageHeight;
@end

@implementation ActivityDetailsViewTests

@synthesize activityDetailsView = activityDetailsView_;
@synthesize partialActivityDetailsView = partialActivitydetailsView_;
@synthesize mockHtmlCreator = mockHtmlCreator_;
@synthesize mockActivityMessageView = mockActivityMessageView_;
@synthesize mockShowEntityButton = mockShowEntityButton_;
@synthesize mockShowEntityView = mockShowEntityView_;
@synthesize mockRecentActivityView = mockRecentActivityView_;

-(void)setUp {
    self.activityDetailsView = [[SocializeActivityDetailsView alloc] init];
    self.partialActivityDetailsView = [OCMockObject partialMockForObject:self.activityDetailsView];
    
    //create/assign the mock html creator to the real object
    self.mockHtmlCreator = [OCMockObject mockForClass:[HtmlPageCreator class]];
    self.activityDetailsView.htmlPageCreator = self.mockHtmlCreator;
    
    //we need to assign this view to the details view property
    self.mockActivityMessageView  = [OCMockObject mockForClass:[UIWebView  class]];
    self.activityDetailsView.activityMessageView = self.mockActivityMessageView;
    
    self.mockShowEntityButton = [OCMockObject mockForClass:[UIButton class]];
    self.activityDetailsView.showEntityButton = self.mockShowEntityButton;
    
    self.mockShowEntityView = [OCMockObject mockForClass:[UIView class]];
    self.activityDetailsView.showEntityView = self.mockShowEntityView;
    
    self.mockRecentActivityView = [OCMockObject mockForClass:[UIView class]];
    self.activityDetailsView.recentActivityView = self.mockRecentActivityView;
}

-(void)tearDown {
    [self.partialActivityDetailsView verify];
    [self.mockHtmlCreator verify];
    [self.mockActivityMessageView verify];
    [self.mockShowEntityButton verify];
    [self.mockShowEntityView verify];
    [self.mockRecentActivityView verify];
    
    self.activityDetailsView = nil;
    self.partialActivityDetailsView = nil;
    self.mockHtmlCreator = nil;
    self.mockActivityMessageView = nil;
    self.mockShowEntityButton = nil;
    self.mockShowEntityView = nil;
    self.mockRecentActivityView = nil;
}

-(void) testUpdateActivityMessage {
    //expect that the load template is called
    [[self.mockHtmlCreator expect] loadTemplate:OCMOCK_ANY];
    [[self.mockHtmlCreator  expect] addInformation:OCMOCK_ANY forTag:@"DATE_TEXT"];
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

- (void)testAwakeFromNibConfiguresButton {
    [[self.mockShowEntityButton expect] addSocializeRoundedGrayButtonImages];
    [self.activityDetailsView awakeFromNib];
}

- (void)expectCommonLayout {
    CGFloat height = 10.f;
    CGRect origFrame = CGRectMake(0, 0, 320, 30);
    [[[self.partialActivityDetailsView stub] andReturnValue:OCMOCK_VALUE(height)] getMessageHeight];
    [[[self.mockActivityMessageView stub] andReturnValue:OCMOCK_VALUE(origFrame)] frame];
    CGRect newFrame = CGRectMake(0, 0, 320, 10);
    [[self.mockActivityMessageView expect] setFrame:newFrame];
    
    // don't care about this one
    [[[self.mockRecentActivityView stub] andReturnValue:OCMOCK_VALUE(CGPointZero)] diagonalPoint];
}

- (void)expectLayoutWithShowEntityButtonNotShown {
    [self expectCommonLayout];
    
    [[self.mockShowEntityView expect] removeFromSuperview];
    [[self.mockRecentActivityView expect] positionBelowView:self.mockActivityMessageView];
}

- (void)expectLayoutWithShowEntityButtonShown {
    [self expectCommonLayout];
    
    [[(id)self.partialActivityDetailsView expect] addSubview:self.mockShowEntityView];
    [[self.mockShowEntityView expect] positionBelowView:self.self.mockActivityMessageView];
    [[self.mockRecentActivityView expect] positionBelowView:self.self.mockShowEntityView];
}


- (void)testShowActivityNotShownWhenNoEntityLoader {
    [Socialize setEntityLoaderBlock:nil];
    [self expectLayoutWithShowEntityButtonNotShown];
    
    [self.partialActivityDetailsView layoutActivityDetailsSubviews];
}

- (void)testShowActivityStillNotShownWhenEntityLoaderButCanNotLoadEntity {
    
    // We have an entity loader defined
    [Socialize setEntityLoaderBlock:^(UINavigationController *controller, id<SocializeEntity>entity) {}];
    
    // But we can not display the entity
    [Socialize setCanLoadEntityBlock:^(id<SocializeEntity> entity) { return NO; }];
    
    [self expectLayoutWithShowEntityButtonNotShown];
    
    [self.partialActivityDetailsView layoutActivityDetailsSubviews];
}

- (void)testShowActivityWithEntityLoaderAndNoCanLoadEntityShowsButton {
    [Socialize setEntityLoaderBlock:^(UINavigationController *nav, id<SocializeEntity>entity){}];
    [Socialize setCanLoadEntityBlock:nil];

    [self expectLayoutWithShowEntityButtonShown];
    
    [self.partialActivityDetailsView layoutActivityDetailsSubviews];
}

@end
