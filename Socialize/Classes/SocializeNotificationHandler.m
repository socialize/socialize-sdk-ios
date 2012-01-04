//
//  SocializeNotificationHandler.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationHandler.h"
#import "SocializeCommentDetailsViewController.h"
#import "Socialize.h"
#import "SocializeCommentsService.h"
#import "SocializeActivityDetailsViewController.h"

static SocializeNotificationHandler *sharedNotificationHandler;

@implementation SocializeNotificationHandler
@synthesize socialize = socialize_;
@synthesize navigationController = navigationController_;
@synthesize displayWindow = displayWindow_;
@synthesize activityDetailsViewController = activityDetailsViewController_;

- (void)dealloc {
    self.socialize = nil;
    self.navigationController = nil;
    self.displayWindow = nil;
    self.activityDetailsViewController = nil;
    
    [super dealloc];
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (UIWindow*)displayWindow {
    if (displayWindow_ == nil) {
        displayWindow_ = [[[UIApplication sharedApplication] keyWindow] retain];
    }
    return displayWindow_;
}

+ (SocializeNotificationHandler*)sharedNotificationHandler {
    if (sharedNotificationHandler == nil) {
        sharedNotificationHandler = [[SocializeNotificationHandler alloc] init];
    }
    return sharedNotificationHandler;
}

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo {
    NSDictionary *socializeDictionary = [userInfo objectForKey:@"socialize"];
    if (socializeDictionary == nil)
        return NO;
    if (![[socializeDictionary objectForKey:@"notification_type"] isEqualToString:@"new_comments"])
        return NO;
    return YES;
}

- (SocializeActivityDetailsViewController*)activityDetailsViewController {
    if (activityDetailsViewController_ == nil) {
        activityDetailsViewController_ = [[SocializeActivityDetailsViewController alloc] init];
    }
    
    return activityDetailsViewController_;
}

- (UINavigationController*)navigationController {
    if (navigationController_ == nil) {
        navigationController_ = [[UINavigationController alloc] initWithRootViewController:self.activityDetailsViewController];
    }
    return navigationController_;
}

-(void)showActivityDetailsForActivityType:(NSString*)activityType activityID:(NSNumber*)activityID {
    NSAssert([activityType isEqualToString:@"comment"], @"Socialize Notification is of type new_comments, but activity is not a comment");
    NSAssert(activityID != nil, @"Socialize Notification is Missing Comment ID");
    
    self.activityDetailsViewController = nil;
    self.navigationController = nil;

    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect windowFrame = self.displayWindow.frame;
    
    self.navigationController.view.frame = CGRectMake(0, statusFrame.size.height, windowFrame.size.width, windowFrame.size.height - statusFrame.size.height);
    [self.displayWindow addSubview:self.navigationController.view];
    
    [self.activityDetailsViewController fetchActivityForType:activityType activityID:activityID];
}

- (BOOL)handleSocializeNotification:(NSDictionary*)userInfo {
    if (![SocializeNotificationHandler isSocializeNotification:userInfo])
        return NO;
    
    NSDictionary *socializeDictionary = [userInfo objectForKey:@"socialize"];
    
    NSNumber *activityID = [socializeDictionary objectForKey:@"activity_id"];
    NSString *activityType = [socializeDictionary objectForKey:@"activity_type"];
    [self showActivityDetailsForActivityType:activityType activityID:activityID];
    
    return YES;
}

@end
