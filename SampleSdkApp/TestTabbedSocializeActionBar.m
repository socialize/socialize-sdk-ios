//
//  TestTabbedSocializeActionBar.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/18/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestTabbedSocializeActionBar.h"

@implementation TestTabbedSocializeActionBar
@synthesize tabBarController = _tabBarController;
@synthesize testSocializeActionBar = _testSocializeActionBar;
@synthesize entityUrl = _entityUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

    [self.view addSubview:self.tabBarController.view];
    self.testSocializeActionBar.entityUrl = self.entityUrl;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.tabBarController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
