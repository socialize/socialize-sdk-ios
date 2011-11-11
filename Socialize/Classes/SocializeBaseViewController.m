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
#import "LoadingView.h"
#import "UINavigationBarBackground.h"
#import "UIButton+Socialize.h"
#import "SocializeProfileViewController.h"

@interface SocializeBaseViewController () <SocializeProfileViewControllerDelegate>
@end

@implementation SocializeBaseViewController
@synthesize tableView = tableView_;
@synthesize doneButton = doneButton_;
@synthesize editButton = editButton_;
@synthesize sendButton = sendButton_;
@synthesize cancelButton = cancelButton_;
@synthesize saveButton = saveButton_;
@synthesize socialize = socialize_;
@synthesize facebookAuthQuestionDialog = facebookAuthQuestionDialog_;
@synthesize postFacebookAuthenticationProfileViewController = postFacebookAuthenticationProfileViewController_;

- (void)dealloc
{
    self.socialize = nil;
    self.facebookAuthQuestionDialog = nil;
    self.postFacebookAuthenticationProfileViewController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.facebookAuthQuestionDialog = nil;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"socialize-navbar-bg.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.doneButton = nil;
    self.editButton = nil;
    self.saveButton = nil;
    self.cancelButton = nil;
    self.sendButton = nil;
    self.facebookAuthQuestionDialog = nil;
    self.postFacebookAuthenticationProfileViewController = nil;
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

- (void)editButtonPressed:(UIButton*)button {
}

- (void)doneButtonPressed:(UIButton*)button {
}

- (void)sendButtonPressed:(UIButton*)button {
}

- (void)cancelButtonPressed:(UIButton*)button {
}

-(void) showAllertWithText: (NSString*)allertMsg andTitle: (NSString*)title
{
    UIAlertView * allert = [[[UIAlertView alloc] initWithTitle:title 
                                                       message:allertMsg 
                                                      delegate:nil 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil] autorelease];
    
    [allert show];
}

- (UIView*)showLoadingInView {
    return self.view;
}

#pragma Location enable/disable button callbacks
-(void) startLoadAnimationForView: (UIView*) view
{
    _loadingIndicatorView = [LoadingView loadingViewInView:view];
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
    else
        [self afterAnonymouslyLoginAction];
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
    [self.navigationController.navigationBar resetBackground];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma socialize service delegate

-(void)service:(SocializeService *)service didFail:(NSError *)error
{
    [self stopLoadAnimation];
    [self showAllertWithText:[error localizedDescription] andTitle:@"Error"];
}

-(void)afterAnonymouslyLoginAction
{
    // Should be implemented in the child classes.
}

- (void)navigationController:(UINavigationController *)localNavigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Visual fixup required for legacy navigation background code (pre-iOS 5)
    [localNavigationController.navigationBar resetBackground];
}


// Facebook authentication flow

- (UIAlertView*)facebookAuthQuestionDialog {
    if (facebookAuthQuestionDialog_ == nil) 
    {
        facebookAuthQuestionDialog_ = [[UIAlertView alloc]
                                       initWithTitle:@"Facebook?" message:@"You are not authenticated with Facebook. Authenticate with Facebook now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    }
    
    return facebookAuthQuestionDialog_;
}

- (void)afterRejectedFacebookAuthentication {
    
}

- (void)afterSuccessfulFacebookAuthentication {
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.facebookAuthQuestionDialog) {
        
        if (buttonIndex == 1) {
            [self authenticateWithFacebook];
        } else {
            [self afterRejectedFacebookAuthentication];
        }
    } 
}

- (void)authenticateWithFacebook {
    if (![self.socialize facebookAvailable]) {
        [self showAllertWithText:@"Proper facebook configuration is required to use this view" andTitle:@"Facebook not Configured"];
        return;
    }
    
    if (![self.socialize isAuthenticatedWithFacebook]) {
        [self startLoading];
        [self.socialize authenticateWithFacebook];
    }
}

- (void)requestFacebookFromUser {
    if (![self.socialize facebookAvailable]) {
        return;
    }

    if (![self.socialize isAuthenticatedWithFacebook]) {
        [self.facebookAuthQuestionDialog show];
    }
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
        // Complete facebook authentication flow
        [self showProfile];
    } else {
        // Complete auto auth
        [self afterAnonymouslyLoginAction];
    }
}

- (void)dismissProfile {
    [self dismissModalViewControllerAnimated:YES];
    [self afterSuccessfulFacebookAuthentication];    
}

- (void)profileViewControllerDidSave:(SocializeProfileViewController *)profileViewController {
    if (profileViewController == self.postFacebookAuthenticationProfileViewController) {
        [self dismissProfile];
    }
}

- (void)profileViewControllerDidCancel:(SocializeProfileViewController *)profileViewController {
    if (profileViewController == self.postFacebookAuthenticationProfileViewController) {
        [self dismissProfile];
    }
}


@end
