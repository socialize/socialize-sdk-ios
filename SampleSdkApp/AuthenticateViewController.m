//
//  AuthenticateViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/10/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "AuthenticateViewController.h"
#import <Socialize-iOS/Socialize.h>
#import "TestListController.h"
#import "UIButton+Socialize.h"

@interface AuthenticateViewController()
-(NSDictionary*)authInfoFromConfig;
@end

@implementation AuthenticateViewController
@synthesize keyField = _keyField;
@synthesize secretField = _secretField;
@synthesize resultLabel = _resultLabel;
@synthesize socialize;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        socialize = [[Socialize alloc] initWithDelegate:self];  

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
    
//    [_authenticateButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];
//    [_thirdpartyAuthentication configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];    
//    [_emptyCacheButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];    

    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"Authenticate";
    
    NSDictionary* apiInfo = [self authInfoFromConfig];
    self.keyField.text = [apiInfo objectForKey:@"key"];
    self.secretField.text = [apiInfo objectForKey:@"secret"];
    
    [Socialize storeSocializeApiKey: [apiInfo objectForKey:@"key"] andSecret: [apiInfo objectForKey:@"secret"]];
    [Socialize storeFacebookAppId:@"115622641859087"];
#if RUN_KIF_TESTS
    [Socialize storeFacebookLocalAppId:@"itest"];
#endif
    
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

-(NSDictionary*)authInfoFromConfig
{
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    NSString * configPath = [bundle pathForResource:@"SocializeApiInfo" ofType:@"plist"];
    NSDictionary * configurationDictionary = [[[NSDictionary alloc]initWithContentsOfFile:configPath] autorelease];
    return  [configurationDictionary objectForKey:@"Socialize API info"];
}

-(IBAction)authenticate:(id)sender {
    
    _loadingView = [LoadingView loadingViewInView:self.view/* withMessage:@"Authenticating"*/]; 
    [socialize authenticateWithApiKey:_keyField.text apiSecret:_secretField.text];

}

-(IBAction)noAuthentication:(id)sender {
    TestListController *listController = [[TestListController alloc] initWithNibName:@"TestListController" bundle:nil];
    [self.navigationController pushViewController:listController animated:YES];

}

-(IBAction)authenticateViaFacebook:(id)sender
{
    _loadingView = [LoadingView loadingViewInView:self.view/* withMessage:@"Authenticating"*/]; 
//   [socialize authenticateWithApiKey:_keyField.text apiSecret:_secretField.text thirdPartyAppId:@"115622641859087" thirdPartyName:FacebookAuth];
    [socialize authenticateWithFacebook];
}

-(IBAction)emptyCache:(id)sender{
    [socialize removeAuthenticationInfo];
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

-(void)didAuthenticate:(id<SocializeUser>)user {
    
    NSLog(@"%@", [user userIdForThirdPartyAuth: FacebookAuth]);
//    NSLog(@"%@", [socialize.authService receiveFacebookAuthToken]);
    
    [_loadingView removeView];
    self.resultLabel.text = @"success";
    TestListController *listController = [[TestListController alloc] initWithNibName:@"TestListController" bundle:nil];
    [self.navigationController pushViewController:listController animated:YES];
    
}

-(void)service:(SocializeService*)service didFail:(NSError*)error {
    
    [_loadingView removeView];
    self.resultLabel.text = @"failed";
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"Authentication failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];

}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    
}

// creating multiple likes or comments would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    
}

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    
}
@end
