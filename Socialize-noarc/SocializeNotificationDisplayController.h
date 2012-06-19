//
//  SocializeNotificationController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/10/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SocializeNotificationDisplayControllerDelegate;

@interface SocializeNotificationDisplayController : NSObject

- (id)initWithUserInfo:(NSDictionary*)userInfo;
- (void)viewWasAdded;

@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, assign) id <SocializeNotificationDisplayControllerDelegate> delegate;
@property (nonatomic, readonly) UIViewController *mainViewController;

@end

@protocol SocializeNotificationDisplayControllerDelegate <NSObject>

- (void)notificationDisplayControllerDidFinish:(SocializeNotificationDisplayController*)notificationDisplayController;

@end