//
//  EntityViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "EntityViewController.h"
#import "LoadingView.h"

@implementation EntityViewController

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
    [_loadingView removeView]; 
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

// creating multiple likes or comments would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    
}

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    [_loadingView removeView]; 
}
@end
