//
//  ProfileEditTableViewCell.m
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeProfileEditTableViewCell.h"

NSInteger SocializeProfileEditTableViewCellHeight = 50;

@implementation SocializeProfileEditTableViewCell

@synthesize keyLabel = keyLabel_;
@synthesize valueLabel = valueLabel_;
@synthesize arrowImageView = arrowImageView_;

- (void)dealloc {
    self.keyLabel = nil;
    self.valueLabel = nil;
    self.arrowImageView = nil;
    
    [super dealloc];
}


@end
