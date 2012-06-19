//
//  SocializeNotificationToggleBubbleContentView.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/12/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationToggleBubbleContentView.h"

@implementation SocializeNotificationToggleBubbleContentView
@synthesize enabledStateLabel = enabledStateLabel_;
@synthesize descriptionLabel = descriptionLabel_;

+ (SocializeNotificationToggleBubbleContentView*)notificationToggleBubbleContentViewFromNib {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil];
    return [objects objectAtIndex:0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)configureForNotificationsEnabled {
    self.enabledStateLabel.text = @"Enabled";
    self.enabledStateLabel.textColor = [UIColor greenColor];
    
    self.descriptionLabel.text = @"We will notify you when someone posts a comment to this discussion.";
}

- (void)configureForNotificationsDisabled {
    self.enabledStateLabel.text = @"Disabled";
    self.enabledStateLabel.textColor = [UIColor redColor];
    
    self.descriptionLabel.text = @"You will no longer receive notifications for updates to this discussion.";
}

- (void)configureForNotificationsEnabled:(BOOL)enabled {
    if (enabled) {
        [self configureForNotificationsEnabled];
    } else {
        [self configureForNotificationsDisabled];
    }
}
    

@end
