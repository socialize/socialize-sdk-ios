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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.cellIcon = nil;
    self.cellLabel = nil;
    self.cellAccessoryIcon = nil;

    [super dealloc];
}

@end
