//
//  TestCreateCommentViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestCreateCommentViewController.h"
#import <Socialize/Socialize.h>
#import "UIButton+Socialize.h"
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
    self.navigationItem.title = @"Create Comment";

    self.view.backgroundColor = [UIColor lightGrayColor];
    [createButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];
    
    resultsView.hidden = YES;
    hiddenButton = [[UIButton alloc] init]; 
    hiddenButton.hidden = YES;
    hiddenButton.accessibilityLabel = @"hiddenButton";
    [self.view addSubview:hiddenButton];
    
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

-(IBAction)createComment {
    if (!hiddenButton) {
        hiddenButton = [[UIButton alloc] init]; 
        hiddenButton.hidden = YES;
        hiddenButton.accessibilityLabel = @"hiddenButton";
        [self.view addSubview:hiddenButton];
    }

    _loadingView = [SocializeLoadingView loadingViewInView:self.view]; 
    [_socialize createCommentForEntityWithKey:entityField.text comment:commentField.text longitude:nil latitude:nil];
}

#pragma Socialize Service callbacks
-(void)service:(SocializeService*)service didFail:(NSError*)error{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;

    resultTextField.text = FAIL;
    [entityField resignFirstResponder];
    [commentField resignFirstResponder];
    [_loadingView removeView]; 
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"cannot create comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
    resultsView.hidden = YES;
}

// creating multiple likes or comments would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;

    [entityField resignFirstResponder];
    [commentField resignFirstResponder];
    
    [_loadingView removeView]; 
    if ([object conformsToProtocol:@protocol(SocializeComment)]){

        id<SocializeComment> comment = (id<SocializeComment>)object;
        resultTextField.text = SUCCESS;
        resultsView.hidden = NO;
        keyLabel.text = [[comment entity] key];   
        nameLabel.text = [[comment entity] name];
        commentsLabel.text = [comment text];

    }
    else{
    
        resultTextField.text = FAIL;
        resultsView.hidden = YES;
    }
}

@end
