//
//  SocializeRecommendCell.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeRecommendCell.h"

@implementation SocializeRecommendCell
@synthesize nameLabel = nameLabel_;
@synthesize commentsCount = commentsCount_;
@synthesize sharesCount = sharesCount_;
@synthesize viewsCount = viewsCount_;
@synthesize likesCount = likesCount_;
@synthesize bgImage = bgImage_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
//    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"comments-cell-bg-borders.png"]];
    self.bgImage.image = [[UIImage imageNamed:@"comments-cell-bg-borders.png"]  stretchableImageWithLeftCapWidth:0 topCapHeight:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
