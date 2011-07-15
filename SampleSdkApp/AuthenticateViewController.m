//
//  AuthenticateViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/10/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "AuthenticateViewController.h"
#import "Socialize.h"

@implementation AuthenticateViewController
@synthesize keyField = _keyField;
@synthesize secretField = _secretField;
@synthesize likeViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        socialize = [[Socialize alloc] initWithDelegate:nil];  
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.keyField = nil;
    self.secretField = nil;
    [socialize release];
    [likeViewController release];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.keyField = nil;
    self.secretField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(IBAction)authenticate:(id)sender{
    [socialize removeAuthenticationInfo];
    [socialize authenticateWithApiKey:_keyField.text apiSecret:_secretField.text delegate:self];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
} 

-(IBAction)backgroundTouched:(id)sender
{
    [_keyField resignFirstResponder];
    [_secretField resignFirstResponder];
}

#pragma mark Authentication delegate

-(void)didAuthenticate
{
    self.likeViewController = [[[LikeViewController alloc] initWithNibName:@"LikeViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:likeViewController animated:YES];
}

-(void)didNotAuthenticate:(NSError*)error
{
///    NSLog(@"  error ")
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"Authentication failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

@end
