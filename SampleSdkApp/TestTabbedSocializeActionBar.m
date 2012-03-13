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
@synthesize entityUrl = _entityUrl;
@synthesize generic1 = _generic1;
@synthesize generic2 = _generic2;
@synthesize actionBar = _actionBar;

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
    
    SocializeEntity *entity = [[[SocializeEntity alloc] init] autorelease];
    entity.key = self.entityUrl;
    entity.name = @"TestBar";
    self.actionBar = [SocializeActionBar actionBarWithKey:self.entityUrl name:@"TestBar" presentModalInController:self];

//    self.actionBar = [SocializeActionBar actionBarWithEntity:entity display:self];

//    self.actionBar = [SocializeActionBar actionBarWithKey:self.entityUrl name:@"TestBar" presentModalInController:self];
    [self.generic1.view addSubview:self.actionBar.view];
    self.generic1.label.text = @"First controller";
    self.generic2.label.text = @"Second controller";
    [self.view addSubview:self.tabBarController.view];
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
