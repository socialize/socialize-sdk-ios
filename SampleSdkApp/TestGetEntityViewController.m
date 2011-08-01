//
//  EntityViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestGetEntityViewController.h"
#import "LoadingView.h"

#define SUCCESS @"success"
#define FAIL @"fail"

@implementation TestGetEntityViewController

@synthesize getEntityResultLabel;


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

-(IBAction)getEntity{
    _loadingView = [LoadingView loadingViewInView:self.view]; 
    [_socialize getEntityByKey:getEntityTextField.text];
}

#pragma socialize service delegate

// for example unlike would result in this callback
-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{

}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{

}

-(void)service:(SocializeService*)service didFail:(NSError*)error{

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

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{

    [getEntityTextField resignFirstResponder];
    [_loadingView removeView]; 

    // we have to verify the contents are of type SocializeEntity 
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object conformsToProtocol:@protocol(SocializeEntity)]){
            id<SocializeEntity> entity = (id<SocializeEntity>)object;
            successLabel.text = SUCCESS;
            resultsView.hidden = NO;
            keyLabel.text = entity.key;
            nameLabel.text = entity.name;
            commentsLabel.text = [NSString stringWithFormat:@"%d", entity.comments];
            likesLabel.text = [NSString stringWithFormat:@"%d", entity.likes];
            sharesLabel.text = [NSString stringWithFormat:@"%d", entity.shares];
        }
    }
    else{
        resultsView.hidden = NO;
        successLabel.text = FAIL;
    }
}

@end
