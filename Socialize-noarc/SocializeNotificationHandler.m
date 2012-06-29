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
#import "SocializeDirectEntityNotificationDisplayController.h"
#import "_Socialize_private.h"

static SocializeNotificationHandler *sharedNotificationHandler;

@implementation SocializeNotificationHandler
@synthesize socialize = socialize_;
@synthesize displayWindow = displayWindow_;
@synthesize displayControllers = displayControllers_;

- (void)dealloc {
    self.socialize = nil;
    self.displayWindow = nil;
    self.displayControllers = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDismiss:) name:SocializeShouldDismissAllNotificationControllersNotification object:nil];
    }
    
    return self;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (NSMutableArray*)displayControllers {
    if (displayControllers_ == nil) {
        displayControllers_ = [[NSMutableArray alloc] init];
    }
    return displayControllers_;
}

- (UIWindow*)displayWindow {
    if (displayWindow_ == nil) {
        displayWindow_ = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] retain];
    }
    return displayWindow_;
}

- (void)addDisplayController:(SocializeNotificationDisplayController*)displayController {
    displayController.delegate = self;
    
    // Cover entire window, except for status bar
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect windowFrame = self.displayWindow.frame;
    displayController.mainViewController.view.frame = CGRectMake(0, statusFrame.size.height, windowFrame.size.width, windowFrame.size.height - statusFrame.size.height);

    // Add as subview
    [self.displayWindow addSubview:displayController.mainViewController.view];
    [self.displayControllers addObject:displayController];
    [displayController viewWasAdded];
}

- (void)dismissAllDisplayControllers {
    for (SocializeNotificationDisplayController *controller in self.displayControllers) {
        if (controller != [self topDisplayController]) {
            [controller.mainViewController.view removeFromSuperview];
        }
    }
    
    [self animatedDismissOfTopDisplayController];
}

- (void)shouldDismiss:(NSNotification*)notification {
    [self dismissAllDisplayControllers];
}

- (SocializeNotificationDisplayController*)topDisplayController {
    return [self.displayControllers lastObject];
}

- (void)removeDisplayController:(SocializeNotificationDisplayController*)displayController {
    SocializeNotificationDisplayController *top = [self topDisplayController];
    NSAssert(top == displayController, @"Socialize: tried to remove non-topmost display controller");
    
    top.delegate = nil;
    [top.mainViewController.view removeFromSuperview];
    [self.displayControllers removeLastObject];
}

- (void)animatedDismissOfTopDisplayController {
    SocializeNotificationDisplayController *top = [self topDisplayController];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = top.mainViewController.view.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         top.mainViewController.view.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeDisplayController:top];
                     }];
}

- (SocializeNewCommentsNotificationDisplayController*)createNewCommentsDisplayControllerForActivityType:(NSString*)activityType activityID:(NSNumber*)activityID {
    SocializeNewCommentsNotificationDisplayController *display = [[[SocializeNewCommentsNotificationDisplayController alloc] init] autorelease];
    
    return display;
}

- (void)notificationDisplayControllerDidFinish:(SocializeNotificationDisplayController*)notificationController {
    [self animatedDismissOfTopDisplayController];    
}

- (BOOL)applicationInForeground {
    return [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
}

- (BOOL)handleSocializeNotification:(NSDictionary*)userInfo {
    
    NSLog(@"Handling notification: %@", userInfo);
    
    // Make sure this is a socialize notification that we are willing to handle in this release
    if (![SocializeNotificationHandler isSocializeNotification:userInfo])
        return NO;
    
    NSDictionary *socializeDictionary = [userInfo objectForKey:@"socialize"];    
    NSString *notificationType = [socializeDictionary objectForKey:@"notification_type"];
    
    if (notificationType == nil) {
        return NO;
    }

    // Track the event
    NSMutableDictionary *eventParams = [NSMutableDictionary dictionaryWithDictionary:socializeDictionary];
    [eventParams setObject:notificationType forKey:@"notification_type"];
    [self.socialize trackEventWithBucket:@"NOTIFICATION_OPEN" values:eventParams];
    

    if ([notificationType isEqualToString:@"new_comments"]) {
        // Don't handle any foreground notifications new_comments, for now
        if ([self applicationInForeground]) {
            return NO;
        }
        
        SocializeNewCommentsNotificationDisplayController *display = [[[SocializeNewCommentsNotificationDisplayController alloc] initWithUserInfo:userInfo] autorelease];
        [self addDisplayController:display];
    } else if ([notificationType isEqualToString:@"developer_direct_url"]) {
        SocializeDirectURLNotificationDisplayController *display = [[[SocializeDirectURLNotificationDisplayController alloc] initWithUserInfo:userInfo] autorelease];
        [self addDisplayController:display];
    } else if ([notificationType isEqualToString:@"developer_direct_entity"]) {
        SocializeDirectEntityNotificationDisplayController *display = [[[SocializeDirectEntityNotificationDisplayController alloc] initWithUserInfo:userInfo] autorelease];
        [self addDisplayController:display];
    } else {
        return NO;
    }

    return YES;
}

+ (SocializeNotificationHandler*)sharedNotificationHandler {
    if (sharedNotificationHandler == nil) {
        sharedNotificationHandler = [[SocializeNotificationHandler alloc] init];
    }
    return sharedNotificationHandler;
}

+ (BOOL)isSocializeNotification:(NSDictionary*)userInfo {
    NSDictionary *socializeDictionary = [userInfo objectForKey:@"socialize"];
    if (socializeDictionary != nil) {
        return YES;
    }
    
    return NO;
}


@end
