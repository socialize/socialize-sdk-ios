/*
 * SocializeBaseViewController.m
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

#import "SocializeBaseViewController.h"
#import "SocializeLoadingView.h"
#import "UINavigationBarBackground.h"
#import "_SZLinkDialogViewController.h"
#import "UIButton+Socialize.h"
#import "_SZUserProfileViewController.h"
#import "SocializeFacebookInterface.h"
#import "SocializeUserService.h"
#import "ImagesCache.h"
#import "SocializeAuthenticateService.h"
#import "SocializeKeyboardListener.h"
#import "UINavigationController+Socialize.h"
#import "SocializePreprocessorUtilities.h"
#import "SocializeThirdPartyFacebook.h"
#import "SZUserUtils.h"
#import <SZBlocksKit/BlocksKit.h>
#import <SZBlocksKit/BlocksKit+UIKit.h>
#import "SDKHelpers.h"
#import "_SZUserSettingsViewController.h"

@interface SocializeBaseViewController () <_SZLinkDialogViewControllerDelegate>
@end

@implementation SocializeBaseViewController
@synthesize delegate = delegate_;
@synthesize tableView = tableView_;
SYNTH_RED_SOCIALIZE_BAR_BUTTON(settingsButton, @"Settings")
SYNTH_BLUE_SOCIALIZE_BAR_BUTTON(doneButton, @"Done")
SYNTH_RED_SOCIALIZE_BAR_BUTTON(cancelButton, @"Cancel")
@synthesize socialize = socialize_;
@synthesize imagesCache = imagesCache_;
@synthesize bundle = bundle_;
@synthesize keyboardListener = keyboardListener_;
@synthesize completionBlock = completionBlock_;
@synthesize cancellationBlock = cancellationBlock_;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
    self.doneButton = nil;
    self.cancelButton = nil;
    self.settingsButton = nil;
    self.socialize.delegate = nil;
    self.socialize = nil;
    self.imagesCache = nil;
    self.bundle = nil;
    self.keyboardListener.delegate = nil;
    self.keyboardListener = nil;
    self.cancellationBlock = nil;
    self.completionBlock = nil;
    self.display = nil;

    [super dealloc];
}

- (BOOL) needNestedModalHack {
    return [UIDevice currentDevice].systemVersion.floatValue >= 6;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                          duration:(NSTimeInterval)duration {
    
    // We are the top modal, make to sure that parent modals use our size
    if ([self needNestedModalHack] && self.presentedViewController == nil && self.presentingViewController != nil) {
        for (UIViewController* parent = self.presentingViewController; parent.presentingViewController != nil; parent = parent.presentingViewController) {
            parent.view.superview.frame = parent.presentedViewController.view.superview.frame;
        }
    }
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                 duration:(NSTimeInterval)duration {
    
    // We are the top modal, make to sure that parent modals are hidden during transition
    if ([self needNestedModalHack] && self.presentedViewController == nil && self.presentingViewController != nil) {
        for (UIViewController* parent = self.presentingViewController; parent.presentingViewController != nil; parent = parent.presentingViewController) {
            parent.view.superview.hidden = YES;
        }
    }
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // We are the top modal, make to sure that parent modals are shown after animation
    if ([self needNestedModalHack] && self.presentedViewController == nil && self.presentingViewController != nil) {
        for (UIViewController* parent = self.presentingViewController; parent.presentingViewController != nil; parent = parent.presentingViewController) {
            parent.view.superview.hidden = NO;
        }
    }
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        (void)self.keyboardListener;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userSettingsChanged:) name:SZUserSettingsDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userChanged:) name:SocializeAuthenticatedUserDidChangeNotification object:nil];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.modalPresentationStyle = UIModalPresentationFormSheet;
        }
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.doneButton = nil;
    self.cancelButton = nil;
    self.settingsButton = nil;
}

- (BOOL)isFormsheetModal {
    return self.modalPresentationStyle == UIModalPresentationFormSheet || self.navigationController.modalPresentationStyle == UIModalPresentationFormSheet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tableView == nil && [self.view isKindOfClass:[UITableView class]]) {
        self.tableView = (UITableView*)self.view;
    }
    
}

- (SocializeKeyboardListener*)keyboardListener {
    if (keyboardListener_ == nil) {
        keyboardListener_ = [[SocializeKeyboardListener alloc] init];
        keyboardListener_.delegate = self;
    }
    
    return keyboardListener_;
}

- (NSBundle*)bundle {
    if (bundle_ == nil) {
        bundle_ = [[NSBundle mainBundle] retain];
    }
    return bundle_;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (ImagesCache*)imagesCache {
    if (imagesCache_ == nil) {
        imagesCache_ = [[ImagesCache sharedImagesCache] retain];
    }
    
    return imagesCache_;
}

- (void)userSettingsChanged:(id<SZFullUser>)updatedSettings {
}

- (void)_userSettingsChanged:(NSNotification*)notification {
    id<SZFullUser> updatedSettings = [[notification userInfo] objectForKey:kSZUpdatedUserKey];
    [self userSettingsChanged:updatedSettings];
}

- (void)userChanged:(id<SZFullUser>)newUser {
}

- (void)_userChanged:(NSNotification*)notification {
    id<SZFullUser> newUser = [notification object];
    [self userChanged:newUser];
}

- (void)changeTitleOnCustomBarButton:(UIBarButtonItem*)barButton toText:(NSString*)text {
    UIButton *button = (UIButton*)[barButton customView];
    [button setTitle:text forState:UIControlStateNormal];
}

-(UIBarButtonItem*) createLeftNavigationButtonWithCaption:(NSString*) caption
{
    UIButton *backButton = [UIButton blueSocializeNavBarBackButtonWithTitle:caption]; 
    [backButton addTarget:self action:@selector(leftNavigationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backLeftItem = [[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    return backLeftItem;
}

- (void)notifyDelegateOfCompletion {
    if (self.completionBlock != nil) {
        self.completionBlock();
    } else {
        if ([self.delegate respondsToSelector:@selector(baseViewControllerDidFinish:)]) {
            [self.delegate baseViewControllerDidFinish:self];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }    
    }
}

- (void)doneButtonPressed:(UIBarButtonItem*)button {
    [self notifyDelegateOfCompletion];
}

- (void)notifyDelegateOfCancellation {
    if (self.cancellationBlock != nil) {
        self.cancellationBlock();
    } else {
        if ([self.delegate respondsToSelector:@selector(baseViewControllerDidCancel:)]) {
            [self.delegate baseViewControllerDidCancel:self];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)cancel {
    self.cancelled = YES;
    [self notifyDelegateOfCancellation];
}

- (void)cancelButtonPressed:(UIButton*)button {
    [self cancel];
}

- (void)settingsButtonPressed:(UIButton *)button {
    _SZUserSettingsViewController *settings = [[[_SZUserSettingsViewController alloc] init] autorelease];
    settings.userSettingsCompletionBlock = ^(BOOL didEdit, id<SZFullUser> user) {
        [self.navigationController popToViewController:self animated:YES];
    };
    
    [self.navigationController pushViewController:settings animated:YES];
}

-(void)leftNavigationButtonPressed:(id)sender {
    //default implementation for the left navigation button
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) showAlertWithText:(NSString*)alertMessage andTitle:(NSString*)title {
    [UIAlertView bk_showAlertViewWithTitle:title message:alertMessage cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
}

- (UIView*)showLoadingInView {
    return self.view;
}

- (void)socializeWillStartLoadingWithMessage:(NSString *)message {
    [self startLoading];
}

- (void)socializeWillStopLoading {
    [self stopLoading];
}

#pragma mark Location enable/disable button callbacks
-(void) startLoadAnimationForView: (UIView*) view
{
    if (_loadingIndicatorView == nil) {
        _loadingIndicatorView = [SocializeLoadingView loadingViewInView:view];
    }
}

-(void) stopLoadAnimation
{
    [_loadingIndicatorView removeView];_loadingIndicatorView = nil;
}

- (void)startLoading {
    [self startLoadAnimationForView:[self showLoadingInView]];
}

- (void)stopLoading {
    [self stopLoadAnimation];
}

-(BOOL)shouldAutoAuthOnAppear {
    return YES;
}

-(void)performAutoAuth
{
    if(![self.socialize isAuthenticated]) {
        // We're Not authenticated at all, and we can't auto auth with facebook
        // Just do anon
        [self startLoading];
        [self.socialize authenticateAnonymously];
    } else {
        [self afterLoginAction:NO];
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self shouldAutoAuthOnAppear]) {
        [self performAutoAuth];
    }
    
    [self.navigationController.navigationBar resetBackground];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar resetBackground];
}

- (void)failWithError:(NSError*)error {
    SZEmitUIError(self, error);
}

-(void)service:(SocializeService *)service didFail:(NSError *)error
{
    [self stopLoadAnimation];
    
    [self failWithError:error];
}

-(void)afterLoginAction:(BOOL)userChanged
{
    // Should be implemented in the child classes.
}

- (void)navigationController:(UINavigationController *)localNavigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Visual fixup required for legacy navigation background code (pre-iOS 5)
    [localNavigationController.navigationBar resetBackground];
}

-(void)didAuthenticate:(id<SocializeUser>)user
{
    [self stopLoadAnimation];
    
    [self afterLoginAction:YES];
}

- (void)loadImageAtURL:(NSString*)imageURL
          startLoading:(void(^)())startLoadingBlock
           stopLoading:(void(^)())stopLoadingBlock
            completion:(void(^)(UIImage *image))completionBlock {
    
    if( imageURL == nil ) {
        //we should return here if the image url is nil
        return;
    }
    // Already have it loaded
    UIImage *existing = [self.imagesCache imageFromCache:imageURL];
    if (existing != nil) {
        completionBlock(existing);
        return;
    }
    
    // Download image
    startLoadingBlock();
    
    // FIXME implementation should handle copy
    CompleteBlock complete = [[^(ImagesCache* imgs){
        stopLoadingBlock();
        
        UIImage *loadedImage = [imgs imageFromCache:imageURL];
        completionBlock(loadedImage);
    } copy] autorelease];
    
    [self.imagesCache loadImageFromUrl:imageURL
                        completeAction:complete];

}

@end
