/*
 * UserProfileViewController.m
 * SocializeSDK
 *
 * Created on 7/4/11.
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

#import "UserProfileViewController.h"

@interface UserProfileViewController()
    -(void)showUserInfo: (BOOL)value;
@end

@implementation UserProfileViewController

@synthesize userPicture;
@synthesize userName;
@synthesize firstName;
@synthesize lastName;
@synthesize city;
@synthesize state;
@synthesize service = _service;
@synthesize progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil service: (Socialize*) socService
{
    NSAssert(socService, @"Could not be nil");
     
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.service = socService;
    }
    return self;
}

- (void)dealloc
{
    [userPicture release]; userPicture = nil;
    [userName release]; userName = nil;
    [firstName release]; firstName = nil;
    [lastName release]; lastName = nil;
    [city release]; city = nil;
    [state release]; state = nil;
    [progressView release]; progressView = nil;
    self.service = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self showUserInfo:NO];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showUserInfo:NO];
    [self.progressView startAnimating];
    
    [self.service setDelegate:self];
    [self.service.userService currentUser];
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    // FIXME can't use services directly in sample app
//    self.service.userService.delegate = nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.userPicture = nil;
    self.userName = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.city = nil;
    self.state = nil;
}

-(void)showUserInfo: (BOOL)value
{
    self.userPicture.hidden = !value;
    self.userName.hidden = !value;
    self.firstName.hidden = !value;
    self.lastName.hidden = !value;
    self.city.hidden = !value;
    self.state.hidden = !value;
}

#pragma mark - actions handlers

-(IBAction)doneBtnAction
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Socialize service delegate

-(void) userService:(SocializeService *)userService didReceiveUser:(id<SocializeUser>)userObject
{
    [self.progressView stopAnimating];
    self.progressView.hidden = YES;
    [self showUserInfo:YES];
    
    if((id)userObject.smallImageUrl != [NSNull null])
    {
        NSData* imageFromService = [NSData dataWithContentsOfURL:[NSURL URLWithString:userObject.smallImageUrl]];
        self.userPicture.image = [UIImage imageWithData:imageFromService];
    }
    
    if((id)userObject.userName != [NSNull null])
        self.userName.text = userObject.userName;
    
    if((id)userObject.firstName != [NSNull null])
        self.firstName.text = userObject.firstName;

    if((id)userObject.lastName != [NSNull null])
        self.lastName.text = userObject.lastName;

    if((id)userObject.city != [NSNull null])
        self.city.text = userObject.city;

    if((id)userObject.state != [NSNull null])
        self.state.text = userObject.state;
}


-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object
{
    DLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object
{
    DLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    self.progressView.hidden = YES;
    [self showUserInfo:YES];
    
    NSLog(@"UserProfileViewController error occurred--- %@", error);
    
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"User service failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];    
    
    [msg show];
    [msg release];
}

-(void)service:(SocializeService*)service didCreateWithElements:(NSArray*)dataArray andErrorList:(id)errorList
{
    DLog(@"didCreateWithElements %@", dataArray);
    [dataArray enumerateObjectsUsingBlock:^(id userObject, NSUInteger idx, BOOL *stop)
     {
         if([userObject conformsToProtocol:@protocol(SocializeUser)])
         {
             [self userService:service didReceiveUser:userObject];
         }
     }
    ];
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray andErrorList:(id)errorList
{
    DLog(@"didFetchElements");
    [dataArray enumerateObjectsUsingBlock:^(id userObject, NSUInteger idx, BOOL *stop)
     {
         if([userObject conformsToProtocol:@protocol(SocializeUser)])
         {
             [self userService:service didReceiveUser:userObject];
         }
     }
    ];
}

@end
