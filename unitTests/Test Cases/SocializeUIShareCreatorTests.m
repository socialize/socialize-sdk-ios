//
//  SocializeShareCreatorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUIShareCreatorTests.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeUIDisplay.h"
#import "UIActionSheet+BlocksKit.h"
#import "MFMailComposeViewController+BlocksKit.h"
#import "MFMessageComposeViewController+BlocksKit.h"
#import "MFMailComposeViewController+BlocksKit.h"
#import "SocializeTwitterAuthenticator.h"
#import "_Socialize.h"
#import "SocializeComposeMessageViewController.h"
#import "SocializeFacebookAuthenticator.h"
#import "SocializePreprocessorUtilities.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeFacebookWallPoster.h"

enum {
    ActionSheetButtonTwitter,
    ActionSheetButtonFacebook,
    ActionSheetButtonEmail,
    ActionSheetButtonSMS,
    ActionSheetButtonCancel,
    ActionSheetButtonNumChoices,
};

// Composer cannot be allocated on simulator
@interface MockSMSComposer : NSObject
+ (BOOL)canSendText;
@property (copy) BKMessageComposeBlock completionBlock;
@property (nonatomic, copy) NSString *body;
@end

@implementation MockSMSComposer
@synthesize completionBlock = completionBlock;
@synthesize body = body_;
- (void)dealloc {
    self.completionBlock = nil;
    self.body = nil;
    
    [super dealloc];
}
+ (BOOL)canSendText { return YES; }

@end

// Real email class is causing issues during tests
@interface MockEmailComposer : NSObject
+ (BOOL)canSendMail;
@property (copy) BKMailComposeBlock completionBlock;
@property (nonatomic, copy) NSString *messageBody;
@property (nonatomic, copy) NSString *subject;
@end

@implementation MockEmailComposer
@synthesize completionBlock = completionBlock;
@synthesize messageBody = messageBody_;
@synthesize subject = subject_;

- (void)dealloc {
    self.completionBlock = nil;
    self.messageBody = nil;
    self.subject = nil;
    
    [super dealloc];
}

- (void)setMessageBody:(NSString *)messageBody isHTML:(BOOL)isHTML {
    [self setMessageBody:messageBody];
}

+ (BOOL)canSendMail { return YES; }
@end

@implementation SocializeUIShareCreatorTests
@synthesize shareCreator = shareCreator_;
@synthesize mockMailComposerClass = mockMailComposerClass_;
@synthesize mockMessageComposerClass = mockMessageComposerClass_;
@synthesize disableMail = disableMail_;
@synthesize disableSMS = disableSMS_;
@synthesize mockApplication = mockApplication_;

- (id)createAction {
    __block id weakSelf = self;
    
    SocializeUIShareCreator *shareCreator = [[[SocializeUIShareCreator alloc] initWithOptions:nil display:self.mockDisplay] autorelease];
    shareCreator.successBlock = ^{
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    shareCreator.failureBlock = ^(NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusFailure];
    };
    
    return shareCreator;
}

- (BOOL)shouldRunOnMainThread {
    return YES;
}

- (void)setUp {
    [super setUp];
    
    [SocializeThirdPartyTwitter startMockingClass];
    [SocializeThirdPartyFacebook startMockingClass];
    [SocializeFacebookAuthenticator startMockingClass];
    [SocializeTwitterAuthenticator startMockingClass];
    [SocializeFacebookWallPoster startMockingClass];
    [[[SocializeThirdPartyTwitter stub] andReturnBool:YES] available];
    [[[SocializeThirdPartyFacebook stub] andReturnBool:YES] available];
    
    self.disableSMS = NO;
    self.disableMail = NO;
    
    self.shareCreator = (SocializeUIShareCreator*)self.action;
    
    self.mockMessageComposerClass = [OCMockObject classMockForClass:[MFMessageComposeViewController class]];
    self.shareCreator.messageComposerClass = self.mockMessageComposerClass;
    [[[self.mockMessageComposerClass stub] andReturnBoolFromBlock:^{ return (BOOL)!self.disableSMS; }] canSendText];
    
    self.mockMailComposerClass = [OCMockObject classMockForClass:[MFMailComposeViewController class]];
    self.shareCreator.mailComposerClass = self.mockMailComposerClass;
    [[[self.mockMailComposerClass stub] andReturnBoolFromBlock:^{ return (BOOL)!self.disableMail; }] canSendMail];
    
    self.mockApplication = [OCMockObject mockForClass:[UIApplication class]];
    self.shareCreator.application = self.mockApplication;
}

- (void)tearDown {
    [super tearDown];
    
    [SocializeThirdPartyTwitter stopMockingClassAndVerify];
    [SocializeThirdPartyFacebook stopMockingClassAndVerify];
    [SocializeFacebookAuthenticator stopMockingClassAndVerify];
    [SocializeTwitterAuthenticator stopMockingClassAndVerify];
    [SocializeFacebookWallPoster stopMockingClassAndVerify];
    
    [self.mockMessageComposerClass verify];
    [self.mockMailComposerClass verify];
    [self.mockApplication verify];
    
    self.shareCreator.successBlock = nil;
    self.shareCreator.failureBlock = nil;
    self.shareCreator = nil;
    self.mockMailComposerClass = nil;
    self.mockMessageComposerClass = nil;
    self.mockApplication = nil;
}

- (void)testCreateDestroy {
    [self expectDeallocationOfObject:self.shareCreator fromTest:_cmd];
}

- (void)respondToActionSheetWithBlock:(void(^)(UIActionSheet*))block {
    [[[self.mockDisplay expect] andDo2:^(id object, UIActionSheet *actionSheet) {
        block(actionSheet);
    }] socializeObject:self.shareCreator requiresDisplayOfActionSheet:OCMOCK_ANY];    
}

- (void)respondToActionSheetWithButtonIndex:(int)buttonIndex {
    [self respondToActionSheetWithBlock:^(UIActionSheet *actionSheet) {
        [actionSheet simulateButtonPressAtIndex:buttonIndex];        
    }];
}

- (void)respondToSMSCompositionWithResult:(MessageComposeResult)result {
    [[[self.mockDisplay expect] andDo2:^(id object, MFMessageComposeViewController *composer) {
        [[self.mockDisplay expect] socializeObject:self.shareCreator requiresDismissOfViewController:composer];
        composer.completionBlock(result);
    }] socializeObject:OCMOCK_ANY requiresDisplayOfViewController:OCMOCK_ANY];
}

- (void)respondToEmailCompositionWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [[[self.mockDisplay expect] andDo2:^(id object, MFMailComposeViewController *composer) {
        [[self.mockDisplay expect] socializeObject:self.shareCreator requiresDismissOfViewController:composer];
        composer.completionBlock(result, error);
    }] socializeObject:OCMOCK_ANY requiresDisplayOfViewController:OCMOCK_ANY];
}

- (void)respondToEmailAlertWithShowSettings:(BOOL)showSettings {
    [[[self.mockDisplay expect] andDo2:^(id object, UIAlertView *alertView) {
        int index = showSettings ? 0 : 1;
        [alertView simulateButtonPressAtIndex:index];
    }] socializeObject:OCMOCK_ANY requiresDisplayOfAlertView:OCMOCK_ANY];
}

- (void)cancelComposition {
    [[[self.mockDisplay expect] andDo2:^(id object, UINavigationController *nav) {
        SocializeBaseViewController *controller =(SocializeBaseViewController*)nav.topViewController;
        [[self.mockDisplay expect] socializeObject:self.shareCreator requiresDismissOfViewController:controller];
        [self.shareCreator baseViewControllerDidCancel:controller];
    }] socializeObject:self.shareCreator requiresDisplayOfViewController:OCMOCK_ANY];
}

- (void)succeedCompositionWithText:(NSString*)text {
    [[[self.mockDisplay expect] andDo2:^(id object, UINavigationController *nav) {
        SocializeComposeMessageViewController *controller =(SocializeComposeMessageViewController*)nav.topViewController;
        [[self.mockDisplay expect] socializeObject:self.shareCreator requiresDismissOfViewController:controller];
        
        id mockTextView = [OCMockObject mockForClass:[UITextView class]];
        [[[mockTextView stub] andReturn:text] text];
        controller.commentTextView = mockTextView;
    
        [self.shareCreator baseViewControllerDidFinish:controller];
    }] socializeObject:self.shareCreator requiresDisplayOfViewController:OCMOCK_ANY];
    
}

- (void)failCreatingShare {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeShare> share) {
        [self.shareCreator service:self.mockSocialize didFail:nil];
    }] createShare:OCMOCK_ANY];
}

- (void)succeedCreatingShareWithText:(NSString*)text {
    [[[self.mockSocialize expect] andDo1:^(id<SocializeShare> share) {
        if (text != nil) {
            GHAssertEqualStrings(share.text, text, @"Share text incorrect");
        }
        [self.shareCreator service:self.mockSocialize didCreate:share];
    }] createShare:OCMOCK_ANY];
}

- (void)testCancellingActionSheetCausesFailure {
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonCancel];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testFailAuthenticatingViaTwitterCausesFailure {
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonTwitter];
    [self failTwitterAuthentication];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSucceedAuthenticatingViaTwitterAndCancellingTextControllerCausesFailure {
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonTwitter];
    [self succeedTwitterAuthentication];
    [self cancelComposition];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSuccessfulTwitterShare {
    [self.mockDisplay makeNice];
    
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonTwitter];
    [self succeedTwitterAuthentication];

    // Composition succeeds
    NSString *testText = @"testText";
    [self succeedCompositionWithText:testText];
    
    // Share should be created with the composition text
    [self succeedCreatingShareWithText:testText];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testFailedTwitterShare {
    [self.mockDisplay makeNice];
    
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonTwitter];
    [self succeedTwitterAuthentication];
    
    // Composition succeeds
    NSString *testText = @"testText";
    [self succeedCompositionWithText:testText];
    
    // Share should be created with the composition text
    [self failCreatingShare];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testFailAuthenticatingViaFacebookCausesFailure {
    
    // Press the facebook button
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonFacebook];
    
    // Fail auth
    [self failFacebookAuthentication];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSucceedAuthenticatingViaFacebookAndCancellingTextControllerCausesFailure {
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonFacebook];
    [self succeedFacebookAuthentication];
    [self cancelComposition];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testSuccessfulFacebookShare {
    [self.mockDisplay makeNice];
    
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonFacebook];
    [self succeedFacebookAuthentication];
    
    // Composition succeeds
    NSString *testText = @"testText";
    [self succeedCompositionWithText:testText];
    
    // Share should be created with the composition text
    [self succeedCreatingShareWithText:testText];
    
    // Post to the wall
    [self succeedPostingToFacebookWall];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testActionSheetDoesNotContainSMSWhenUnavailable {
    self.disableSMS = YES;
    
    [self respondToActionSheetWithBlock:^(UIActionSheet* actionSheet) {
        GHAssertEquals([actionSheet numberOfButtons], ActionSheetButtonNumChoices - 1, @"bad button count");
        
        // hit cancel
        [actionSheet simulateButtonPressAtIndex:ActionSheetButtonCancel - 1];
    }];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)SMSCompositionFailureTestWithResult:(MessageComposeResult)result {
    // MessageComposer cannot be allocated on simulator
    self.shareCreator.messageComposerClass = [MockSMSComposer class];
    
    // Select SMS
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonSMS];
    
    // Cancel SMS
    [self respondToSMSCompositionWithResult:MessageComposeResultCancelled];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testFailingSMSCompositionCausesFailure {
    [self SMSCompositionFailureTestWithResult:MessageComposeResultFailed];
}

- (void)testCancellingSMSCompositionCausesFailure {
    [self SMSCompositionFailureTestWithResult:MessageComposeResultCancelled];
}

- (void)testSucceedingSMSCompositionCreatesShareAndSucceeds {
    [self.mockDisplay makeNice];

    // MessageComposer cannot be allocated on simulator
    self.shareCreator.messageComposerClass = [MockSMSComposer class];
    
    // Select SMS
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonSMS];
    
    // Cancel SMS
    [self respondToSMSCompositionWithResult:MessageComposeResultSent];
    
    // Share should be created with the composition text
    [self succeedCreatingShareWithText:nil];

    [self executeActionAndWaitForStatus:kGHUnitWaitStatusSuccess fromTest:_cmd];
}

- (void)testUnconfiguredEmailShowsAlertShowsSettingsAndFailsIfSettingsSelected {
    self.disableMail = YES;
    
    // Select Email
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonEmail];
    
    [[self.mockApplication expect] openURL:OCMOCK_ANY];
    
    [self respondToEmailAlertWithShowSettings:YES];
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testUnconfiguredEmailShowsAlertFailsIfSettingsNotSelected {
    self.disableMail = YES;
    
    // Select Email
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonEmail];
    
    [self respondToEmailAlertWithShowSettings:NO];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)emailCompositionFailureTestWithResult:(MFMailComposeResult)result {
    // MessageComposer cannot be allocated on simulator
    self.shareCreator.mailComposerClass = [MockEmailComposer class];

    // Select Email
    [self respondToActionSheetWithButtonIndex:ActionSheetButtonEmail];
    
    [self respondToEmailCompositionWithResult:result error:nil];
    
    [self executeActionAndWaitForStatus:kGHUnitWaitStatusFailure fromTest:_cmd];
}

- (void)testFailingEmailCompositionCausesFailure {
    [self emailCompositionFailureTestWithResult:MFMailComposeResultFailed];
}

- (void)testCancellingEmailCompositionCausesFailure {
    [self emailCompositionFailureTestWithResult:MFMailComposeResultCancelled];
}

- (void)testSavingEmailCompositionCausesFailure {
    [self emailCompositionFailureTestWithResult:MFMailComposeResultSaved];
}

- (void)testDefaultApplication {
    self.shareCreator.application = nil;
    GHAssertEquals(self.shareCreator.application, [UIApplication sharedApplication], @"not equal");
}

@end
