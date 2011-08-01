//
//  TestCreateCommentViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestCreateCommentViewController.h"
#import "SocializeService.h"
#import "SocializeComment.h"

#define SUCCESS @"success"
#define FAIL @"fail"

@implementation TestCreateCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _socialize = [[Socialize alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
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

-(IBAction)createComment{
    _loadingView = [LoadingView loadingViewInView:self.view]; 
    [_socialize createCommentForEntityWithKey:entityField.text comment:commentField.text];
}

#pragma Socialize Service callbacks
-(void)service:(SocializeService*)service didFail:(NSError*)error{
    
    [entityField resignFirstResponder];
    [commentField resignFirstResponder];
    [_loadingView removeView]; 
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"cannot create comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
    resultsView.hidden = YES;
    successLabel.text = FAIL;
}

// creating multiple likes or comments would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    
    [entityField resignFirstResponder];
    [commentField resignFirstResponder];
    
    [_loadingView removeView]; 
    if ([object conformsToProtocol:@protocol(SocializeComment)]){
        id<SocializeComment> comment = (id<SocializeComment>)object;
        resultsView.hidden = NO;
        successLabel.text = SUCCESS;
        keyLabel.text = [[comment entity] key];   
        nameLabel.text = [[comment entity] name];
        commentsLabel.text = [comment text];
    }
    else{
        resultsView.hidden = YES;
        successLabel.text = FAIL;
    }
}

@end
