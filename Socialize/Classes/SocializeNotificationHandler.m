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
@synthesize activityDetailsViewController = activityDetailsViewController_;
@synthesize displayWindow = displayWindow_;

- (void)dealloc {
    self.socialize = nil;
    self.activityDetailsViewController = nil;
    self.displayWindow = nil;
    
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

-(void)showActivityDetailsForActivityType:(NSString*)activityType activityID:(NSNumber*)activityID {
    NSAssert([activityType isEqualToString:@"comment"], @"Socialize Notification is of type new_comments, but activity is not a comment");
    NSAssert(activityID != nil, @"Socialize Notification is Missing Comment ID");
    
    [self.socialize getCommentById:[activityID integerValue]];
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

- (void)showActivityForComment:(id<SocializeComment>)comment {
    self.activityDetailsViewController = [[[SocializeActivityDetailsViewController alloc] init] autorelease];
    self.activityDetailsViewController.view.frame = CGRectMake(0, 20, 320, 460);
    [self.displayWindow addSubview:self.activityDetailsViewController.view];
}

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    id<SocializeComment> comment = (id<SocializeComment>)[dataArray objectAtIndex:0];
    [self showActivityForComment:comment];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
//    NSAssert(nil, @"%@", error);
}

@end
