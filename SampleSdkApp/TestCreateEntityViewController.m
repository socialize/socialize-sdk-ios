//
//  TestCreateViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/27/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestCreateEntityViewController.h"
#import "UIButton+Socialize.h"

@implementation TestCreateEntityViewController
@synthesize  createEntityResultLabel;

#define SUCCESS @"success"
#define FAIL @"fail"

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
    self.navigationItem.title = @"Create Entity";

    resultsView.hidden = YES;
    hiddenButton = [[UIButton alloc] init]; 
    hiddenButton.hidden = YES;
    hiddenButton.accessibilityLabel = @"hiddenButton";
    [self.view addSubview:hiddenButton];

    self.view.backgroundColor = [UIColor lightGrayColor];
    [createButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];

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

#pragma mark entity creation

-(IBAction)createEntity{

    if (!hiddenButton){
        hiddenButton = [[UIButton alloc] init]; 
        hiddenButton.hidden = YES;
        hiddenButton.accessibilityLabel = @"hiddenButton";
        [self.view addSubview:hiddenButton];
    }

    _loadingView = [SocializeLoadingView loadingViewInView:self.view]; 
    [_socialize createEntityWithKey:createEntityUrlTextField.text name:createEntityNameTextField.text];
}

-(IBAction)backgroundTouched{   
    [createEntityUrlTextField resignFirstResponder];
    [createEntityNameTextField resignFirstResponder];
}


#pragma Socialize Service callbacks

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    
    resultTextField.text = FAIL;

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;
    
    [createEntityUrlTextField resignFirstResponder];
    [createEntityNameTextField resignFirstResponder];

    [_loadingView removeView]; 
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"cannot create entity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
    resultsView.hidden = YES;
}

// creating multiple likes or comments would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    
    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;

    [createEntityUrlTextField resignFirstResponder];
    [createEntityNameTextField resignFirstResponder];
    
    [_loadingView removeView]; 
    if ([object conformsToProtocol:@protocol(SocializeEntity)]){

        id<SocializeEntity> entity = (id<SocializeEntity>)object;
        resultsView.hidden = NO;
        successLabel.text = SUCCESS;
        keyLabel.text = entity.key;
        nameLabel.text = entity.name;
        commentsLabel.text = [NSString stringWithFormat:@"%d", entity.comments];
        likesLabel.text = [NSString stringWithFormat:@"%d", entity.likes];
        sharesLabel.text = [NSString stringWithFormat:@"%d", entity.shares];
        resultTextField.text = SUCCESS;

    }
    else{
        resultTextField.text = FAIL;
        resultsView.hidden = YES;
    }
}


@end
