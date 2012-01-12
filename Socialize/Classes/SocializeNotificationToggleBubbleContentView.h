//
//  SocializeNotificationToggleBubbleContentView.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/12/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocializeNotificationToggleBubbleContentView : UIView
+ (SocializeNotificationToggleBubbleContentView*)notificationToggleBubbleContentViewFromNib;

@property (nonatomic, retain) IBOutlet UILabel *enabledStateLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

- (void)configureForNotificationsEnabled:(BOOL)enabled;

@end
