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

@end
