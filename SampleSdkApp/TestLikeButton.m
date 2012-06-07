//
//  TestLikeButton.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestLikeButton.h"

@interface TestLikeButton ()

@end

@implementation TestLikeButton
@synthesize entity = entity_;

- (id)initWithEntity:(id<SocializeEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    SZLikeButton *likeButton = [[SZLikeButton alloc] initWithFrame:CGRectMake(120, 30, 0, 0) entity:self.entity viewController:self];
    [self.view addSubview:likeButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
