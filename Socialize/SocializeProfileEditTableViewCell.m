//
//  ProfileEditTableViewCell.m
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeProfileEditTableViewCell.h"


@implementation SocializeProfileEditTableViewCell

@synthesize keyLabel;
@synthesize valueLabel;
@synthesize theImageView;
@synthesize spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [keyLabel release]; keyLabel = nil;
	[valueLabel release]; valueLabel = nil;
	[theImageView release]; theImageView = nil;
	[spinner release]; spinner = nil;
    
    [super dealloc];
}


@end
