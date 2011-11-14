//
//  AuthorizeInfoTableViewCell.m
//  appbuildr
//
//  Created by Fawad Haider  on 5/23/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeAuthInfoTableViewCell.h"


@implementation SocializeAuthInfoTableViewCell
@synthesize cellIcon;
@synthesize cellLabel;
@synthesize cellSubLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.cellLabel    = nil;
    self.cellSubLabel = nil;
    self.cellIcon     = nil;
    [super dealloc];
}

@end
