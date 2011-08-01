//
//  TestLikeViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestLikeViewController.h"


#define SUCCESS @"success"
#define FAIL @"fail"

@implementation TestLikeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _socialize = [[Socialize alloc ] initWithDelegate:self]; 
    }
    return self;
}

- (void)dealloc
{
    [_socialize release];
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
    resultsView.hidden = YES;
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

#pragma mark IBActions

-(IBAction)toggleLike{
    _loadingView = [LoadingView loadingViewInView:self.view]; 
    [_socialize likeEntityWithKey:getEntityTextField.text longitude:nil latitude:nil];
}

#pragma socialize service delegate
// for example unlike would result in this callback
-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    
    
    _isLiked = NO;
    [getEntityTextField resignFirstResponder];
    [_loadingView removeView]; 
    successLabel.text = FAIL;
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"no entity found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
    
    // setting up labels
}

-(IBAction)backgroundTouched{
    [getEntityTextField resignFirstResponder];
}


-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    _isLiked = NO;
    [getEntityTextField resignFirstResponder];
    [_loadingView removeView]; 
}

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    
    _isLiked = YES;
    [getEntityTextField resignFirstResponder];
    [_loadingView removeView]; 
    
    // we have to verify the contents are of type SocializeEntity 
    if ([object conformsToProtocol:@protocol(SocializeLike)]){
        successLabel.text = SUCCESS;
        resultsView.hidden = NO;
    }
    else{
        resultsView.hidden = NO;
        successLabel.text = FAIL;
    }
}
@end
