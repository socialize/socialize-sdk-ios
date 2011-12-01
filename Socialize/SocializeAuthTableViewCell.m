//
//  AuthorizeTableViewCell.m
//  appbuildr
//
//  Created by Fawad Haider  on 5/19/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeAuthTableViewCell.h"


@implementation SocializeAuthTableViewCell

@synthesize cellIcon;
@synthesize cellLabel;
@synthesize cellAccessoryIcon;

- (void)dealloc
{
    self.cellIcon = nil;
    self.cellLabel = nil;
    self.cellAccessoryIcon = nil;

    [super dealloc];
}

@end
