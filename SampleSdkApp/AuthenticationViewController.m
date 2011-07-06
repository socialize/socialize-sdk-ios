/*
 * AuthenticationViewController.m
 * SocializeSDK
 *
 * Created on 7/6/11.
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

#import "AuthenticationViewController.h"
#import "SampleSdkAppAppDelegate.h"

#define FACEBOOK_AUTH_TYPE 1

@implementation AuthenticationViewController
@synthesize service;
@synthesize faceBook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil service: (Socialize*) socService
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.service = socService;
        self.faceBook = [(SampleSdkAppAppDelegate*)[UIApplication sharedApplication].delegate facebook];
    }
    return self;
}

- (void)dealloc
{
    [fbButton release]; fbButton = nil;
    self.service = nil;
    self.faceBook = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kFACEBOOK_ACCESS_TOKEN_KEY] 
        && [defaults objectForKey:kFACEBOOK_EXPIRATION_DATE_KEY]) {
        faceBook.accessToken = [defaults objectForKey:kFACEBOOK_ACCESS_TOKEN_KEY];
        faceBook.expirationDate = [defaults objectForKey:kFACEBOOK_EXPIRATION_DATE_KEY];
        fbButton.isLoggedIn = YES;
    }
    else
        fbButton.isLoggedIn = NO;
    
    [fbButton updateImage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Custom actions

-(IBAction)fbButtonClick:(id)sender
{
    if (fbButton.isLoggedIn) {
        [faceBook logout:self];
    } else {
        [faceBook authorize:nil delegate:self];
    }
}

#pragma mark - Facebook delegate

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[faceBook accessToken] forKey:kFACEBOOK_ACCESS_TOKEN_KEY];
    [defaults setObject:[faceBook expirationDate] forKey:kFACEBOOK_EXPIRATION_DATE_KEY];
    [defaults synchronize];
    fbButton.isLoggedIn = YES;
    [fbButton updateImage];
    
//    [self.service authenticateWithApiKey:@"" apiSecret:@"" udid:@"someid" thirdPartyAuthToken:faceBook.accessToken thirdPartyUserId:@"115622641859087" thirdPartyName:FACEBOOK_AUTH_TYPE delegate:nil];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kFACEBOOK_ACCESS_TOKEN_KEY];
    [defaults removeObjectForKey:kFACEBOOK_EXPIRATION_DATE_KEY];
    [defaults synchronize];
    fbButton.isLoggedIn = NO;
    [fbButton updateImage];
}

@end
