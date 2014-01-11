//
//  SocializeActivityDetailsViewIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/10/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SocializeActivityDetailsViewIOS6.h"

@implementation SocializeActivityDetailsViewIOS6

- (void)awakeFromNib {
    UIImage *activityHeaderImage = [UIImage imageNamed:@"socialize-activity-details-back-section-x.png"];
    self.recentActivityHeaderImage.image = activityHeaderImage;
    UIImage *entityImage = [[UIImage imageNamed:@"socialize-activity-details-btn-link.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.showEntityButton setBackgroundImage:entityImage forState:UIControlStateNormal];
}

@end
