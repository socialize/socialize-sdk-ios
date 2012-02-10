/*
 * TestShowSmallUserInfo.m
 * SocializeSDK
 *
 * Created on 9/19/11.
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

#import "TestShowSmallUserInfo.h"
#import <Socialize/Socialize.h>


@implementation TestShowSmallUserInfo

@synthesize userName;
@synthesize fbUserId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _socialize = [[Socialize alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [userName release];
    [fbUserId release];
    [_socialize release];
    [_user release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loadingView = [SocializeLoadingView loadingViewInView:self.view]; 
    [_socialize getCurrentUser];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.userName = nil;
    self.fbUserId = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Socialize service delegate

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [_loadingView removeView];_loadingView = nil;

    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:[NSString stringWithFormat: @"cannot get profile %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    [_loadingView removeView];_loadingView = nil;
    
    _user = [[dataArray objectAtIndex:0] retain];
    self.userName.text = _user.userName;
//    
//    NSNumber* fbId = [_user userIdForThirdPartyAuth:SocializeThirdPartyAuthTypeFacebook];
//    if(fbId)
//        self.fbUserId.text = [NSString stringWithFormat:@"%d", fbId];
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object
{
    [_loadingView removeView];_loadingView = nil;
}

-(IBAction)updateBtn
{
    _loadingView = [SocializeLoadingView loadingViewInView:self.view]; 
    
    [_user setUserName:@"Sergey"];
    [_socialize updateUserProfile:_user];    
}

@end
