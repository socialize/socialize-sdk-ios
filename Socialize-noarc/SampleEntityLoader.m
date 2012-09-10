//
//  SampleEntityLoader.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SampleEntityLoader.h"

@implementation SampleEntityLoader
@synthesize entity = entity_;
@synthesize entityNameLabel = entityNameLabel_;
@synthesize entityKeyLabel = entityKeyLabel_;

- (void)dealloc {
    self.entity = nil;
    self.entityNameLabel = nil;
    self.entityKeyLabel = nil;
    
    [super dealloc];
}

- (id)initWithEntity:(id<SocializeEntity>)entity
{
    self = [super init];
    if (self) {
        self.entity = entity;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.entityKeyLabel.text = self.entity.key;
    self.entityNameLabel.text = self.entity.name;
    
    self.title = self.entity.name;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

@end
