/*
 * SocializeBaseViewController.h
 * SocializeSDK
 *
 * Created on 9/26/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "_Socialize.h"
#import "SocializeKeyboardListener.h"
#import "SocializeProfileEditViewControllerDelegate.h"
#import "SocializeUIDisplay.h"

@class SocializeShareBuilder;
@class SocializeLoadingView;
@class ImagesCache;
@class SocializeProfileEditViewController;

@protocol SocializeBaseViewControllerDelegate;

@interface SocializeBaseViewController : UIViewController<SocializeServiceDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, SocializeProfileEditViewControllerDelegate, SocializeKeyboardListenerDelegate, SocializeUIDisplay> {
    @private 
    SocializeLoadingView*  _loadingIndicatorView;
}
@property (nonatomic, assign) id<SocializeBaseViewControllerDelegate> delegate;
@property(nonatomic, retain) UINavigationController* authViewController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) UIAlertView *genericAlertView;
@property (nonatomic, retain) UIAlertView *sendActivityToFacebookFeedAlertView;
@property (nonatomic, retain) SocializeShareBuilder *shareBuilder;
@property (nonatomic, retain) ImagesCache *imagesCache;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) SocializeKeyboardListener *keyboardListener;
@property (nonatomic, retain) SocializeProfileEditViewController *profileEditViewController;
@property (nonatomic, retain) UINavigationController *navigationControllerForEdit;

-(void) showAlertWithText: (NSString*)allertMsg andTitle: (NSString*)title;
-(void) startLoading;
-(void) stopLoading;
-(void) startLoadAnimationForView: (UIView*) view;
-(void) stopLoadAnimation;
-(void)performAutoAuth;
-(void) afterLoginAction:(BOOL)userChanged;
-(BOOL)shouldAutoAuthOnAppear;
- (UIView*)showLoadingInView;
- (void)authenticateWithFacebook;
- (BOOL)shouldShowAuthViewController;
- (void)sendActivityToFacebookFeed:(id<SocializeActivity>)activity;
- (void)sendActivityToFacebookFeedSucceeded;
- (void)sendActivityToFacebookFeedFailed:(NSError*)error;
- (void)sendActivityToFacebookFeedCancelled;
- (UIBarButtonItem*)createLeftNavigationButtonWithCaption:(NSString*)caption;
- (void)getCurrentUser;
- (void)didGetCurrentUser:(id<SocializeFullUser>)fullUser;
- (void)loadImageAtURL:(NSString*)imageURL
          startLoading:(void(^)())startLoadingBlock
           stopLoading:(void(^)())stopLoadingBlock
            completion:(void(^)(UIImage *image))completionBlock;
- (void)changeTitleOnCustomBarButton:(UIBarButtonItem*)barButton toText:(NSString*)text;
- (void)doneButtonPressed:(UIBarButtonItem*)button;
- (void)cancelButtonPressed:(UIBarButtonItem*)button;
- (void)settingsButtonPressed:(UIBarButtonItem*)button;
- (void)showEditController;
- (void)notifyDelegateOfCompletion;
- (void)notifyDelegateOfCancellation;
- (void)failWithError:(NSError*)error;
- (BOOL)dontShowErrors;
- (void)postErrorNotificationForError:(NSError*)error;

@end

#define SYNTH_RED_SOCIALIZE_BAR_BUTTON(PROPERTY, TITLESTR) \
@synthesize PROPERTY = PROPERTY ## _; \
- (UIBarButtonItem*)PROPERTY { \
    if (PROPERTY ## _ == nil) { \
        UIButton *button = [UIButton redSocializeNavBarButtonWithTitle: TITLESTR ]; \
        [button addTarget:self action:@selector(PROPERTY ## Pressed:) forControlEvents:UIControlEventTouchUpInside]; \
        PROPERTY ## _ = [[UIBarButtonItem alloc] initWithCustomView:button]; \
    } \
    return PROPERTY ## _; \
}

#define SYNTH_BLUE_SOCIALIZE_BAR_BUTTON(PROPERTY, TITLESTR) \
@synthesize PROPERTY = PROPERTY ## _; \
- (UIBarButtonItem*)PROPERTY { \
    if (PROPERTY ## _ == nil) { \
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle: TITLESTR ]; \
        [button addTarget:self action:@selector(PROPERTY ## Pressed:) forControlEvents:UIControlEventTouchUpInside]; \
        PROPERTY ## _ = [[UIBarButtonItem alloc] initWithCustomView:button]; \
    } \
    return PROPERTY ## _; \
}

