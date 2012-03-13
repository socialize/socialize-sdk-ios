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
#import "SocializeAuthViewController.h"
#import "UIButton+Socialize.h"
#import "SocializeProfileViewController.h"
#import "SocializeShareBuilder.h"
#import "SocializeFacebookInterface.h"
#import "SocializeUserService.h"
#import "ImagesCache.h"
#import "SocializeAuthenticateService.h"
#import "SocializeKeyboardListener.h"
#import "UINavigationController+Socialize.h"
#import "SocializePreprocessorUtilities.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeFacebookAuthenticator.h"

@interface SocializeBaseViewController () <SocializeAuthViewControllerDelegate>
-(void)leftNavigationButtonPressed:(id)sender;
-(void)showEditController;
@end

@implementation SocializeBaseViewController
@synthesize delegate = delegate_;
@synthesize tableView = tableView_;
SYNTH_RED_SOCIALIZE_BAR_BUTTON(settingsButton, @"Settings")
SYNTH_BLUE_SOCIALIZE_BAR_BUTTON(doneButton, @"Done")
SYNTH_RED_SOCIALIZE_BAR_BUTTON(cancelButton, @"Cancel")
@synthesize genericAlertView = genericAlertView_;
@synthesize socialize = socialize_;
@synthesize imagesCache = imagesCache_;
@synthesize shareBuilder = shareBuilder_;
@synthesize sendActivityToFacebookFeedAlertView = sendActivityToFacebookFeedAlertView_;
@synthesize authViewController = authViewController_;
@synthesize bundle = bundle_;
@synthesize keyboardListener = keyboardListener_;
@synthesize profileEditViewController = profileEditViewController_;
@synthesize navigationControllerForEdit = navigationControllerForEdit_;

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
    self.doneButton = nil;
    self.cancelButton = nil;
    self.settingsButton = nil;
    self.genericAlertView.delegate = nil;
    self.genericAlertView = nil;
    self.socialize.delegate = nil;
    self.socialize = nil;
    self.imagesCache = nil;
    self.shareBuilder.successAction = nil;
    self.shareBuilder.errorAction = nil;
    self.shareBuilder = nil;
    self.sendActivityToFacebookFeedAlertView = nil;
    self.authViewController = nil;
    self.bundle = nil;
    self.keyboardListener.delegate = nil;
    self.keyboardListener = nil;
    self.profileEditViewController = nil;
    self.navigationControllerForEdit = nil;

    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.doneButton = nil;
    self.cancelButton = nil;
    self.settingsButton = nil;
    self.genericAlertView = nil;
    self.sendActivityToFacebookFeedAlertView = nil;
    self.authViewController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyboardListener = [[[SocializeKeyboardListener alloc] init] autorelease];
    self.keyboardListener.delegate = self;
    
    if (self.tableView == nil && [self.view isKindOfClass:[UITableView class]]) {
        self.tableView = (UITableView*)self.view;
    }
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
    if ([self.delegate respondsToSelector:@selector(baseViewControllerDidFinish:)]) {
        [self.delegate baseViewControllerDidFinish:self];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }    
}

- (void)doneButtonPressed:(UIBarButtonItem*)button {
    [self notifyDelegateOfCompletion];
}

- (void)notifyDelegateOfCancellation {
    if ([self.delegate respondsToSelector:@selector(baseViewControllerDidCancel:)]) {
        [self.delegate baseViewControllerDidCancel:self];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }    
}

- (void)cancelButtonPressed:(UIButton*)button {
    [self notifyDelegateOfCancellation];
}

- (void)settingsButtonPressed:(UIButton *)button {
    [self showEditController];
}


-(void)leftNavigationButtonPressed:(id)sender {
    //default implementation for the left navigation button
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIAlertView*)genericAlertView {
    if (genericAlertView_ == nil) {
        genericAlertView_ = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    
    return genericAlertView_;
}

-(void) showAlertWithText:(NSString*)alertMessage andTitle:(NSString*)title
{
    self.genericAlertView.message = alertMessage;
    self.genericAlertView.title = title;
    [self.genericAlertView show];
}

- (UIView*)showLoadingInView {
    return self.view;
}

#pragma Location enable/disable button callbacks
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

-(BOOL) shouldShowAuthViewController {
    return ( ![self.socialize isAuthenticatedWithThirdParty] && [self.socialize thirdPartyAvailable]);
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

- (BOOL)dontShowErrors {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeUIErrorAlertsDisabled] boolValue];
}

- (void)postErrorNotificationForError:(NSError*)error {
    NSDictionary *userInfo = nil;
    if (error != nil) {
        userInfo = [NSDictionary dictionaryWithObject:error forKey:SocializeUIControllerErrorUserInfoKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeUIControllerDidFailWithErrorNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)failWithError:(NSError*)error {
    [self postErrorNotificationForError:error];
    
    if ([[error domain] isEqualToString:SocializeErrorDomain] && [error code] == SocializeErrorServerReturnedHTTPError) {
        NSHTTPURLResponse *response = [[error userInfo] objectForKey:kSocializeErrorNSHTTPURLResponseKey];
        if ([response statusCode] == 401) {
            [self.socialize removeSocializeAuthenticationInfo];
        }
    }

    if (![self dontShowErrors]) {
        [self showAlertWithText:[error localizedDescription] andTitle:@"Error"];
    }
    
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.sendActivityToFacebookFeedAlertView) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self sendActivityToFacebookFeedCancelled];
        }
        else if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self sendActivityToFacebookFeed:self.shareBuilder.shareObject];
        }
    }
}

- (void)authenticateWithFacebook {
    if (![SocializeThirdPartyFacebook available]) {
        [self showAlertWithText:@"Proper facebook configuration is required to use this view" andTitle:@"Facebook not Configured"];
        return;
    }
    
    if (![SocializeThirdPartyFacebook isLinkedToSocialize]) {
        [SocializeFacebookAuthenticator authenticateViaFacebookWithOptions:nil
                                                                   display:self
                                                                   success:^{
                                                                       [self afterLoginAction:YES];
                                                                   } failure:^(NSError *error) {
                                                                       [self showAlertWithText:[error localizedDescription] andTitle:@"Error"];
                                                                   }];
    }
}
-(UINavigationController *)authViewController{    
    if(!authViewController_) {
        authViewController_ = [[SocializeAuthViewController authViewControllerInNavigationController:self] retain];
    }
    return authViewController_;
}

-(void)didAuthenticate:(id<SocializeUser>)user
{
    [self stopLoadAnimation];
    
    [self afterLoginAction:YES];
}

- (UIAlertView*)sendActivityToFacebookFeedAlertView {
    if (sendActivityToFacebookFeedAlertView_ == nil) {
        sendActivityToFacebookFeedAlertView_ = [[UIAlertView alloc]
                                                initWithTitle:@"Facebook Error"
                                                message:nil
                                                delegate:self
                                                cancelButtonTitle:@"Dismiss"
                                                otherButtonTitles:@"Retry", nil];
    }
    
    return sendActivityToFacebookFeedAlertView_;
}

- (void)sendActivityToFacebookFeedSucceeded {
    [self stopLoading];
}
    
- (void)sendActivityToFacebookFeedFailed:(NSError*)error {
    [self stopLoading];
    
    NSString *message = @"There was a Problem Writing to Your Facebook Wall";
    
    // Provide more detailed error if available
    NSString *facebookErrorType = [[[error userInfo] objectForKey:@"error"] objectForKey:@"type"];
    NSString *facebookErrorMessage = [[[error userInfo] objectForKey:@"error"] objectForKey:@"message"];
    if (facebookErrorType != nil && facebookErrorMessage != nil) {
        message = [NSString stringWithFormat:@"%@: %@", facebookErrorType, facebookErrorMessage];
    }
    
    self.sendActivityToFacebookFeedAlertView.message = message;
    
    [self.sendActivityToFacebookFeedAlertView show];
}

- (void)sendActivityToFacebookFeedCancelled {
    
}

- (SocializeShareBuilder*)shareBuilder {
    if (shareBuilder_ == nil) {
        shareBuilder_ = [[SocializeShareBuilder alloc] init];
        shareBuilder_.shareProtocol = [[[SocializeFacebookInterface alloc] init] autorelease];
        
        __block __typeof__(self) weakSelf = self;
        shareBuilder_.successAction = ^{
            [weakSelf sendActivityToFacebookFeedSucceeded];
        };
        shareBuilder_.errorAction = ^(NSError *error) {
            [weakSelf sendActivityToFacebookFeedFailed:error];
        };
        
    }
    return shareBuilder_;
}

- (void)sendActivityToFacebookFeed:(id<SocializeActivity>)activity {
    [self startLoading];
    self.shareBuilder.shareObject = activity;
    [self.shareBuilder performShareForPath:@"me/feed"];
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

- (void)getCurrentUser {
    [self startLoading];
    [self.socialize getCurrentUser];
}

- (void)didGetCurrentUser:(id<SocializeFullUser>)fullUser {
    
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    [self stopLoading];
    
    if ([service isKindOfClass:[SocializeUserService class]]) {
        id<SocializeFullUser> fullUser = [dataArray objectAtIndex:0];
        NSAssert([fullUser conformsToProtocol:@protocol(SocializeFullUser)], @"Not a socialize user");
        [self didGetCurrentUser:fullUser];
    }
}

- (SocializeProfileEditViewController*)profileEditViewController {
    if (profileEditViewController_ == nil) {
        profileEditViewController_ = [[SocializeProfileEditViewController alloc]
                                      init];
        profileEditViewController_.delegate = self;
    }
    return profileEditViewController_;
}

- (UINavigationController*)navigationControllerForEdit {
    if (navigationControllerForEdit_ == nil) {
        navigationControllerForEdit_ = [[UINavigationController socializeNavigationControllerWithRootViewController:self.profileEditViewController] retain];
        navigationControllerForEdit_.delegate = self;
    }
    return navigationControllerForEdit_;
}

-(void)showEditController
{
    [self presentModalViewController:self.navigationControllerForEdit animated:YES];
}


-(void)hideEditController
{
    [self stopLoading];
    [self dismissModalViewControllerAnimated:YES];
    self.navigationControllerForEdit = nil;
    self.profileEditViewController.delegate = nil;
    self.profileEditViewController = nil;
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    if (baseViewController == self.profileEditViewController) {
        [self hideEditController];    
    }
}

- (void)profileEditViewController:(SocializeProfileEditViewController *)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user {
    [self hideEditController];
}

- (void)socializeObjectWillStartLoading:(id)object {
    [self startLoading];
}

- (void)socializeObjectWillStopLoading:(id)object {
    [self stopLoading];
}

@end
