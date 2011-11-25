//
//  ActivityTableViewCell.m
//  appbuildr
//
//  Created by Isaac Mosquera on 11/23/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import "SocializeActivityTableViewCell.h"

NSString *const SocializeActivityTableViewCellReuseIdentifier = @"SocializeActivityTableViewCell";
const CGFloat SocializeActivityTableViewCellHeight = 74.0f;

@implementation SocializeActivityTableViewCell
@synthesize nameLabel;
@synthesize activityTextLabel;
@synthesize profileImageView;
@synthesize activityIcon;
@synthesize informationView;
@synthesize profileView;
@synthesize commentTextLabel;
@synthesize btnViewProfile;
@synthesize profileImageActivity = profileImageActivity_;
@synthesize disclosureImage = disclosureImage_;

- (void) dealloc
{
    self.nameLabel = nil;
    self.btnViewProfile = nil;
    self.activityTextLabel = nil;
    self.commentTextLabel = nil;
    self.profileImageView = nil;
    self.activityIcon = nil;
    self.informationView = nil;
    self.profileImageActivity = nil;
    self.disclosureImage = nil;
    
	[super dealloc];
}


@end
