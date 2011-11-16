//
//  TestViewCreationViewController.m
//  SocializeSDK
//
//  Created by Sergey Popenko on 8/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestViewCreationViewController.h"
#import <Socialize/Socialize.h>
#import "UIButton+Socialize.h"

#define SUCCESS @"success"
#define FAIL @"fail"

@implementation TestViewCreationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _socialize = [[Socialize alloc]initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [entityTextField release];
    [_socialize release];
    [resultsView release];
    [successLabel release];
    [keyLabel release];
    [nameLabel release];
    [commentsLabel release];
    [likesLabel release];
    [sharesLabel release];
    [viewsLabel release];
    [super dealloc];
}

-(IBAction)createView
{
    _loadingView = [SocializeLoadingView loadingViewInView:self.view]; 
    id<SocializeEntity> entity = (id<SocializeEntity>)[_socialize createObjectForProtocol: @protocol(SocializeEntity)];
    [entity setKey:entityTextField.text];
    [_socialize viewEntity:entity longitude:nil latitude:nil];
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
    self.navigationItem.title = @"Test create a view";

    self.view.backgroundColor = [UIColor lightGrayColor];
    [createButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];
    
    resultsView.hidden =  YES; 
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

#pragma mark - Socialize delegate

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [entityTextField resignFirstResponder];
    [_loadingView removeView]; 
    successLabel.text = successLabel.accessibilityValue = FAIL;
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"no entity found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

// creating multiple likes or comments would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object
{
    [entityTextField resignFirstResponder];
    [_loadingView removeView]; 
    
    if ([object conformsToProtocol:@protocol(SocializeView)]){
        id<SocializeView> view = (id<SocializeView>)object;
        successLabel.text = successLabel.accessibilityValue = SUCCESS;
        resultsView.hidden = NO;
        
        keyLabel.text = view.entity.key;
        nameLabel.text = view.entity.name;
        
        commentsLabel.text = [NSString stringWithFormat:@"%d", view.entity.comments];
        likesLabel.text = [NSString stringWithFormat:@"%d", view.entity.likes];
        sharesLabel.text = [NSString stringWithFormat:@"%d", view.entity.shares];
        viewsLabel.text = [NSString stringWithFormat:@"%d", view.entity.views];
    }
    else{
        resultsView.hidden = YES;
        successLabel.text = successLabel.accessibilityValue = FAIL;
    }
}

@end
