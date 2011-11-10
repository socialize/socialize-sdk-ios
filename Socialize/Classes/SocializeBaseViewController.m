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


@implementation SocializeBaseViewController
@synthesize doneButton = doneButton_;
@synthesize editButton = editButton_;
@synthesize sendButton = sendButton_;
@synthesize cancelButton = cancelButton_;
@synthesize saveButton = saveButton_;
@synthesize socialize = socialize_;

- (void)dealloc
{
    self.socialize = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"socialize-navbar-bg.png"]];
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (UIBarButtonItem*)saveButton {
    if (saveButton_ == nil) {
        UIButton *button = [[UIButton blueSocializeNavBarButtonWithTitle:@"Save"] retain];
        [button addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        saveButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return saveButton_;
}

- (UIBarButtonItem*)cancelButton {
    if (cancelButton_ == nil) {
        UIButton *button = [[UIButton redSocializeNavBarButtonWithTitle:@"Cancel"] retain];
        [button addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return cancelButton_;
}

- (UIBarButtonItem*)sendButton {
    if (doneButton_ == nil) {
        UIButton *button = [[UIButton blueSocializeNavBarButtonWithTitle:@"Send"] retain];
        [button addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        sendButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return sendButton_;
}

- (UIBarButtonItem*)doneButton {
    if (doneButton_ == nil) {
        UIButton *button = [[UIButton blueSocializeNavBarButtonWithTitle:@"Done"] retain];
        [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        doneButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return doneButton_;
}

- (UIBarButtonItem*)editButton {
    if (editButton_ == nil) {
        UIButton *button = [[UIButton redSocializeNavBarButtonWithTitle:@"Edit"] retain];
        [button addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        editButton_ = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return editButton_;
}

- (void)editButtonPressed:(UIBarButtonItem*)button {
}

- (void)doneButtonPressed:(UIBarButtonItem*)button {
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
    [self startLoadAnimationForView:self.view];
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
        [self startLoadAnimationForView: self.view];
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
    
    [self.navigationController.navigationBar resetBackground:1234];

}

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar resetBackground:1234];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma socialize service delegate

-(void)didAuthenticate:(id<SocializeUser>)user
{
    [self stopLoadAnimation];
    [self afterAnonymouslyLoginAction];
}

-(void)service:(SocializeService *)service didFail:(NSError *)error
{
    [self stopLoadAnimation];
    [self showAllertWithText:[error localizedDescription] andTitle:@"Authentication"];
}

-(void)afterAnonymouslyLoginAction
{
    // Should be implemented in the child classes.
}

- (void)navigationController:(UINavigationController *)localNavigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // This is weird. 1234 is special tag set by our UINavigationBar setBackgroundImage: on iOS pre-5.0
    // It is used because somehow the background image moves to the front after some controller transitions
    [localNavigationController.navigationBar resetBackground:1234];
}



@end
