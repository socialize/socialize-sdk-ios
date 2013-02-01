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
#import "_SZUserSettingsViewControllerDelegate.h"
#import "SZDisplay.h"

@class SocializeLoadingView;
@class ImagesCache;
@class _SZUserSettingsViewController;

@protocol SocializeBaseViewControllerDelegate;

@interface SocializeBaseViewController : UIViewController<SocializeServiceDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, SocializeKeyboardListenerDelegate, SocializeBaseViewControllerDelegate> {
    @private 
    SocializeLoadingView*  _loadingIndicatorView;
}
@property (nonatomic, assign) id<SocializeBaseViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) ImagesCache *imagesCache;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) SocializeKeyboardListener *keyboardListener;
@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic, copy) void (^cancellationBlock)();
@property (nonatomic, unsafe_unretained) id<SZDisplay> display;
@property (nonatomic, assign) BOOL cancelled;

- (BOOL)isFormsheetModal;
-(void) showAlertWithText:(NSString*)alertMessage andTitle:(NSString*)title;
-(void) startLoading;
-(void) stopLoading;
-(void) startLoadAnimationForView: (UIView*) view;
-(void) stopLoadAnimation;
-(void)performAutoAuth;
-(void) afterLoginAction:(BOOL)userChanged;
-(BOOL)shouldAutoAuthOnAppear;
- (UIView*)showLoadingInView;
- (UIBarButtonItem*)createLeftNavigationButtonWithCaption:(NSString*)caption;
- (void)loadImageAtURL:(NSString*)imageURL
          startLoading:(void(^)())startLoadingBlock
           stopLoading:(void(^)())stopLoadingBlock
            completion:(void(^)(UIImage *image))completionBlock;
- (void)changeTitleOnCustomBarButton:(UIBarButtonItem*)barButton toText:(NSString*)text;
- (void)doneButtonPressed:(UIBarButtonItem*)button;
- (void)cancelButtonPressed:(id)button;
- (void)settingsButtonPressed:(UIBarButtonItem*)button;
- (void)notifyDelegateOfCompletion;
- (void)notifyDelegateOfCancellation;
- (void)failWithError:(NSError*)error;
- (void)userSettingsChanged:(id<SZFullUser>)updatedSettings;
- (void)userChanged:(id<SZFullUser>)newUser;
- (void)cancel;

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

