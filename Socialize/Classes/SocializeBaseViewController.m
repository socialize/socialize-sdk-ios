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

@interface SocializeBaseViewController () <SocializeProfileViewControllerDelegate, SocializeAuthViewControllerDelegate>
-(void)leftNavigationButtonPressed:(id)sender;  
@end

@implementation SocializeBaseViewController
@synthesize tableView = tableView_;
@synthesize doneButton = doneButton_;
@synthesize editButton = editButton_;
@synthesize sendButton = sendButton_;
@synthesize cancelButton = cancelButton_;
@synthesize saveButton = saveButton_;
@synthesize genericAlertView = genericAlertView_;
@synthesize socialize = socialize_;
@synthesize postFacebookAuthenticationProfileViewController = postFacebookAuthenticationProfileViewController_;
@synthesize requestingFacebookFromUser = requestingFacebookFromUser_;
@synthesize shareBuilder = shareBuilder_;
@synthesize sendActivityToFacebookFeedAlertView = sendActivityToFacebookFeedAlertView_;
@synthesize authViewController = authViewController_;
- (void)dealloc
{
    self.genericAlertView.delegate = nil;
    self.genericAlertView = nil;
    self.socialize.delegate = nil;
    self.socialize = nil;
    self.postFacebookAuthenticationProfileViewController = nil;
    self.shareBuilder = nil;
    self.sendActivityToFacebookFeedAlertView = nil;
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.doneButton = nil;
    self.editButton = nil;
    self.saveButton = nil;
    self.cancelButton = nil;
    self.sendButton = nil;
    self.genericAlertView = nil;
    self.postFacebookAuthenticationProfileViewController = nil;
    self.sendActivityToFacebookFeedAlertView = nil;
    self.authViewController = nil;
}

- (UITableView*)tableView {
    if (tableView_ == nil) {
        if ([self.view isKindOfClass:[UITableView class]]) {
            tableView_ = (UITableView*)self.view;
        }
    }
    
    return tableView_;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (UIBarButtonItem*)saveButton {
    if (saveButton_ == nil) {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Save"];
        [button addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        saveButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return saveButton_;
}

- (UIBarButtonItem*)cancelButton {
    if (cancelButton_ == nil) {
        UIButton *button = [UIButton redSocializeNavBarButtonWithTitle:@"Cancel"];
        [button addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return cancelButton_;
}

- (UIBarButtonItem*)sendButton {
    if (sendButton_ == nil) {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Send"];
        [button addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        sendButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return sendButton_;
}

-(UIBarButtonItem*) createLeftNavigationButtonWithCaption:(NSString*) caption
{
    UIButton *backButton = [UIButton blueSocializeNavBarBackButtonWithTitle:caption]; 
    [backButton addTarget:self action:@selector(leftNavigationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backLeftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    return backLeftItem;
}
-(void)leftNavigationButtonPressed:(id)sender {
    //default implementation for the left navigation button
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem*)doneButton {
    if (doneButton_ == nil) {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Done"];
        [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        doneButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return doneButton_;
}

- (UIBarButtonItem*)editButton {
    if (editButton_ == nil) {
        UIButton *button = [UIButton redSocializeNavBarButtonWithTitle:@"Edit"];
        [button addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        editButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return editButton_;
}

- (void)saveButtonPressed:(UIButton*)button {
}

- (void)editButtonPressed:(UIButton*)button {
}

- (void)doneButtonPressed:(UIButton*)button {
}

- (void)sendButtonPressed:(UIButton*)button {
}

- (void)cancelButtonPressed:(UIButton*)button {
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

-(void)performAutoAuth
{
    if(![self.socialize isAuthenticated])
    {
        [self startLoading];
        [self.socialize authenticateAnonymously];
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

-(void)service:(SocializeService *)service didFail:(NSError *)error
{
    [self stopLoadAnimation];
    [self showAlertWithText:[error localizedDescription] andTitle:@"Error"];
}

-(void)afterAnonymouslyLoginAction
{
    // Should be implemented in the child classes.
}

-(void)afterFacebookLoginAction
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
    if (![self.socialize facebookAvailable]) {
        [self showAlertWithText:@"Proper facebook configuration is required to use this view" andTitle:@"Facebook not Configured"];
        return;
    }
    
    if (![self.socialize isAuthenticatedWithFacebook]) {
        [self startLoading];
        [self.socialize authenticateWithFacebook];
    }
}
-(UINavigationController *)authViewController{    
    if(!authViewController_) {
        authViewController_ = [[SocializeAuthViewController authViewControllerInNavigationController:self] retain];
    }
    return authViewController_;
}

- (SocializeProfileViewController*)postFacebookAuthenticationProfileViewController {
    if (postFacebookAuthenticationProfileViewController_ == nil) {
        postFacebookAuthenticationProfileViewController_ = [[SocializeProfileViewController alloc] init];
        postFacebookAuthenticationProfileViewController_.delegate = self;
    }
    
    return postFacebookAuthenticationProfileViewController_;
}

- (void)showProfile {
    
    UINavigationController *navigationController = [[[UINavigationController alloc]
                                                     initWithRootViewController:self.postFacebookAuthenticationProfileViewController]
                                                    autorelease];
    
    [self presentModalViewController:navigationController animated:YES];
}

-(void)didAuthenticate:(id<SocializeUser>)user
{
    [self stopLoadAnimation];
    
    if ([self.socialize isAuthenticatedWithFacebook]) {
        if (self.requestingFacebookFromUser) {
            // Complete facebook authentication flow
            [self showProfile];
        } else {
            [self afterFacebookLoginAction];
        }
    } else {
        // Complete auto auth
        [self afterAnonymouslyLoginAction];
    }
}

- (void)dismissFacebookAuthProfile {
    self.requestingFacebookFromUser = NO;
    [self dismissModalViewControllerAnimated:YES];
    [self afterFacebookLoginAction];
}

- (void)profileViewControllerDidSave:(SocializeProfileViewController *)profileViewController {
    if (profileViewController == self.postFacebookAuthenticationProfileViewController) {
        [self dismissFacebookAuthProfile];
    }
}

- (void)profileViewControllerDidCancel:(SocializeProfileViewController *)profileViewController {
    if (profileViewController == self.postFacebookAuthenticationProfileViewController) {
        [self dismissFacebookAuthProfile];
    }
}

- (UIAlertView*)sendActivityToFacebookFeedAlertView {
    if (sendActivityToFacebookFeedAlertView_ == nil) {
        sendActivityToFacebookFeedAlertView_ = [[UIAlertView alloc]
                                                initWithTitle:@"Facebook Error"
                                                message:@"There was a Problem Writing to Your Facebook Wall"
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
    [self.sendActivityToFacebookFeedAlertView show];
}

- (void)sendActivityToFacebookFeedCancelled {
    
}

- (SocializeShareBuilder*)shareBuilder {
    if (shareBuilder_ == nil) {
        shareBuilder_ = [[SocializeShareBuilder alloc] init];
        shareBuilder_.shareProtocol = [[[SocializeFacebookInterface alloc] init] autorelease];
        shareBuilder_.successAction = ^{
            [self sendActivityToFacebookFeedSucceeded];
        };
        shareBuilder_.errorAction = ^(NSError *error) {
            [self sendActivityToFacebookFeedFailed:error];
        };
        
    }
    return shareBuilder_;
}

- (void)sendActivityToFacebookFeed:(id<SocializeActivity>)activity {
    [self startLoading];
    self.shareBuilder.shareObject = activity;
    [self.shareBuilder performShareForPath:@"me/feed"];
}



@end
