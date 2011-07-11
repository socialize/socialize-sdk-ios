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
@synthesize entityListViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        socialize = [[Socialize alloc] init];  
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.keyField = nil;
    self.secretField = nil;
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)authenticate:(id)sender{

//    if([socialize isAuthenticated])
//        return;
    // removing the previous auth tokens
    [socialize removeAuthenticationInfo];
    
    //#define kSOCIALIZE_API_KEY          // stage     
    //#define kSOCIALIZE_API_SECRET       // stage
    
    [socialize authenticateWithApiKey:@"90aa0fb5-1995-4771-9ed9-f3c4479a9aaa"/*_keyField.text*/ apiSecret:@"5f461d4b-999c-430d-a2b2-2df35ff3a9ba"/*_secretField.text*/ udid:@"someid" delegate:self];
}

#pragma mark Authentication delegate

-(void)didAuthenticate
{
    entityListViewController = [[[EntityListViewController alloc] initWithStyle: UITableViewStylePlain andService: socialize] autorelease];

    [self.navigationController pushViewController:entityListViewController animated:YES];
}

-(void)didNotAuthenticate:(NSError*)error
{
    NSLog(@"%@", error);
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"Authentication failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];    
    
    [msg show];
    [msg release];
}

#pragma mark -
@end
