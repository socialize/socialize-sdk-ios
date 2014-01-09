//
//  CommentsTableViewCellIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/8/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "CommentsTableViewCellIOS6.h"

@implementation CommentsTableViewCellIOS6

- (void)awakeFromNib {
	self.bgImage.image = [[UIImage imageNamed:@"comments-cell-bg-borders.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:1];
}

- (UIImage *)defaultBackgroundImage {
    return [UIImage imageNamed:@"socialize-cell-bg.png"];
}

- (UIImage *)defaultProfileImage {
    return [UIImage imageNamed:@"socialize-cell-image-default.png"];
}

@end
