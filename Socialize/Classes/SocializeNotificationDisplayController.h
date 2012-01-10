//
//  SocializeNotificationController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/10/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocializeNotificationDisplayControllerDelegate;

@interface SocializeNotificationDisplayController : NSObject

@property (nonatomic, assign) id <SocializeNotificationDisplayControllerDelegate> delegate;
@property (nonatomic, copy) NSString *activityType;
@property (nonatomic, copy) NSNumber *activityID;
@property (nonatomic, readonly) UIViewController *mainViewController;

@end

@protocol SocializeNotificationDisplayControllerDelegate <NSObject>

- (void)notificationDisplayControllerDidFinish:(SocializeNotificationDisplayController*)notificationDisplayController;

@end