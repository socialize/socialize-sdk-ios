//
//  SocializeBaseViewControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "ImagesCache.h"
#import "SocializeTestCase.h"

@class SocializeBaseViewController;

@interface SocializeBaseViewControllerTests : SocializeTestCase
+ (SocializeBaseViewController*)createController;
@property (nonatomic, retain) SocializeBaseViewController *viewController;
@property (nonatomic, retain) SocializeBaseViewController *origViewController;
@property (nonatomic, retain) id mockNavigationController;
@property (nonatomic, retain) id mockNavigationItem;
@property (nonatomic, retain) id mockNavigationBar;
@property (nonatomic, retain) id mockSocialize;
@property (nonatomic, retain) id mockGenericAlertView;
@property (nonatomic, retain) id mockDoneButton;
@property (nonatomic, retain) id mockCancelButton;
@property (nonatomic, retain) id mockSettingsButton;
@property (nonatomic, retain) id mockBundle;
@property (nonatomic, retain) id mockImagesCache;
@property (nonatomic, retain) id mockView;
@property (nonatomic, retain) id mockWindow;
@property (nonatomic, retain) id mockKeyboardListener;
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, retain) id mockProfileEditViewController;

- (void)expectServiceFailure;
- (void)expectAndSimulateLoadOfImage:(UIImage*)image fromURL:(NSString*)url;
- (void)expectViewWillAppear;
- (void)expectChangeTitleOnCustomBarButton:(id)mockButton toText:(NSString*)text;
- (void)assertBarButtonCallsSelector:(UIBarButtonItem *)item selector:(SEL)selector;
- (void)expectDelegateNotifiedOfCompletion;
@end

#define SYNTH_BUTTON_TEST(CONTROLLER_PROPERTY, BUTTON_PROPERTY) \
- (void)testSelectorIsCalled__ ## BUTTON_PROPERTY { \
    self.CONTROLLER_PROPERTY.BUTTON_PROPERTY  = nil; \
    [self assertBarButtonCallsSelector:self.CONTROLLER_PROPERTY.BUTTON_PROPERTY selector:@selector(BUTTON_PROPERTY ## Pressed:)]; \
}

