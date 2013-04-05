//
//  SZNotificationHandler.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/30/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZNotificationHandler.h"
#import "SZEventUtils.h"
#import "SocializeRichPushNotificationViewController.h"
#import "SZWindowDisplay.h"
#import "socialize_globals.h"
#import "SZEntityUtils.h"
#import "SZCommentsListViewController.h"
#import "SocializeActivityDetailsViewController.h"
#import "SZActionUtils.h"
#import "SZCommentUtils.h"
#import "SZDisplayUtils.h"
#import "SZSmartAlertUtils.h"

static SZNotificationHandler *sharedNotificationHandler;

@interface SZNotificationHandler ()
@property (nonatomic, strong) id<SZDisplay> defaultDisplay;
@property (nonatomic, strong) NSMutableArray *currentStack;
@property (nonatomic, strong) id<SZDisplay> activeOuterDisplay;
@end

@implementation SZNotificationHandler

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAllNotifications:) name:SocializeShouldDismissAllNotificationControllersNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismissAllNotifications:(NSNotification*)notification {
    [self.activeOuterDisplay socializeRequiresDismissModalViewControllerAnimated:YES completion:nil];
    self.activeOuterDisplay = nil;
    self.currentStack = nil;
}

- (NSMutableArray*)currentStack {
    if (_currentStack == nil) {
        _currentStack = [NSMutableArray array];
    }
    
    return _currentStack;
}

+ (SZNotificationHandler*)sharedNotificationHandler {
    if (sharedNotificationHandler == nil) {
        sharedNotificationHandler = [[self alloc] init];
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

- (void)presentViewController:(UIViewController*)viewController inDisplay:(id<SZDisplay>)display {
    
    // Keep track of the very first (outmost) display used in case we need to dismiss everything
    if (self.activeOuterDisplay == nil) {
        self.activeOuterDisplay = display;
    }
    
    [self.currentStack addObject:viewController];
    [display socializeRequiresPresentModalViewController:viewController animated:YES completion:nil];
}

- (void)dismissViewControllerInDisplay:(id<SZDisplay>)display {
    [display socializeRequiresDismissModalViewControllerAnimated:YES completion:nil];
    [self.currentStack removeLastObject];
    
    if (display == self.activeOuterDisplay) {
        self.activeOuterDisplay = nil;
    }
}

- (id<SZDisplay>)defaultDisplay {
    if (_defaultDisplay == nil) {
        _defaultDisplay = [SZDisplayUtils globalDisplay];
    }
    
    return _defaultDisplay;
}

- (void)showDirectEntityNotificationForDisplay:(id<SZDisplay>)display socializeDictionary:(NSDictionary*)socializeDictionary {
    NSNumber *entityId = [socializeDictionary objectForKey:@"entity_id"];
    NSString *notificationType = [socializeDictionary objectForKey:@"notification_type"];

    SZLoadingContext loadingContext;
    if ([notificationType isEqualToString:@"developer_direct_entity"]) {
        loadingContext = SZLoadingContextFetchingEntityForDirectEntityNotification;
    } else if ([notificationType isEqualToString:@"entity_notification"]) {
        loadingContext = SZLoadingContextFetchingEntityForEntitySubscriptionNotification;
    } else {
        @throw [NSException exceptionWithName:@"SocializeException" reason:@"Bad Notification Type" userInfo:nil];
    }
    
    [display socializeDidStartLoadingForContext:loadingContext];
    
    [SZEntityUtils getEntitiesWithIds:@[ entityId ] success:^(NSArray *entities) {
        [display socializeDidStopLoadingForContext:loadingContext];
        id<SZEntity> entity = [entities lastObject];

        if (![SZEntityUtils showEntityLoaderForEntity:entity]) {
            NSLog(@"Socialize Warning: Could not show entity %@ when handling entity notification", entity);
            return;
        }
        
    } failure:^(NSError *error) {
        [display socializeDidStopLoadingForContext:loadingContext];
        [display socializeRequiresIndicationOfFailureForError:error];
    }];
}

- (BOOL)applicationInForeground {
    return [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
}

- (BOOL)handleSocializeNotification:(NSDictionary*)userInfo {
    NSString *notificationType = [[userInfo objectForKey:@"socialize"] objectForKey:@"notification_type"];
    
    if ([notificationType isEqualToString:@"new_comments"] && [self applicationInForeground]) {
        // Legacy behavior for new_comments
        return NO;
    }
    
    return [self openSocializeNotification:userInfo];
}

- (BOOL)openSocializeNotification:(NSDictionary*)userInfo {
    
    NSLog(@"Handling notification: %@", userInfo);
    
    // Make sure this is a socialize notification that we are willing to handle in this release
    if (![[self class] isSocializeNotification:userInfo])
        return NO;
    
    NSDictionary *socializeDictionary = [userInfo objectForKey:@"socialize"];
    NSString *notificationType = [socializeDictionary objectForKey:@"notification_type"];
    
    if (notificationType == nil) {
        return NO;
    }

    id<SZDisplay> display = nil;
    if ([self.currentStack count] > 0) {
        
        // Send display events to the top view controller
        display = [self.currentStack lastObject];
    } else {
        
        // Try to find a developer-defined outer display, since we don't have a top controller to work with
        if ([self displayBlock] != nil) {
            display = [self displayBlock]();
        }
        
        // Fall back to our default outer display
        if (display == nil) {
            display = self.defaultDisplay;
        }
        
        self.activeOuterDisplay = display;
    }
    
    
    // Track the event
    NSMutableDictionary *eventParams = [NSMutableDictionary dictionaryWithDictionary:socializeDictionary];
    [eventParams setObject:notificationType forKey:@"notification_type"];
    [SZEventUtils trackEventWithBucket:@"NOTIFICATION_OPEN" values:eventParams success:nil failure:nil];
    
    if ([notificationType isEqualToString:@"new_comments"]) {
        NSNumber *activityID = [socializeDictionary objectForKey:@"activity_id"];
        if (activityID == nil) {
            NSLog(@"Socialize Warning: new_comments missing activity");
            return YES;
        }
        
        NSString *activityType = [socializeDictionary objectForKey:@"activity_type"];
        if (![activityType isEqualToString:@"comment"]) {
            NSLog(@"Socialize Warning: new_comments activity type should be comment");
            return YES;
        }
        
        [display socializeDidStartLoadingForContext:SZLoadingContextFetchingCommentForNewCommentsNotification];
        [SZCommentUtils getCommentsWithIds:@[ activityID ] success:^(NSArray *comments) {
            id<SZComment> comment = [comments lastObject];
            if (comment == nil) {
                NSLog(@"Socialize Warning: Did not find comment for new_comments notification");
                return;
            }
            
            [display socializeDidStopLoadingForContext:SZLoadingContextFetchingCommentForNewCommentsNotification];

            SocializeNewCommentsNotificationBlock newComments = [SZSmartAlertUtils newCommentsNotificationBlock];
            
            if (newComments) {
                newComments(comment);
            } else {
                SZCommentsListViewController *commentsList = [[SZCommentsListViewController alloc] initWithEntity:comment.entity];
                
                commentsList.completionBlock = ^{
                    [self dismissViewControllerInDisplay:display];
                };
                
                commentsList._commentsListViewController.showNotificationHintOnAppear = YES;

                SocializeActivityDetailsViewController *details = [[SocializeActivityDetailsViewController alloc] initWithActivity:comment];
                [commentsList pushViewController:details animated:YES];
                
                
                [self presentViewController:commentsList inDisplay:display];
            }

        } failure:^(NSError *error) {
            [display socializeDidStopLoadingForContext:SZLoadingContextFetchingCommentForNewCommentsNotification];
            [display socializeRequiresIndicationOfFailureForError:error];
        }];
    } else if ([notificationType isEqualToString:@"developer_direct_url"]) {
        SocializeRichPushNotificationViewController *richPush = [[SocializeRichPushNotificationViewController alloc] init];
        richPush.title = [socializeDictionary objectForKey:@"title"];
        richPush.url = [socializeDictionary objectForKey:@"url"];
        richPush.completionBlock = ^{
            [self dismissViewControllerInDisplay:display];
        };
        richPush.cancellationBlock = ^{
            [self dismissViewControllerInDisplay:display];
        };

        SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:richPush];
        [self presentViewController:nav inDisplay:display];

    } else if ([notificationType isEqualToString:@"developer_direct_entity"]) {
        if ([Socialize entityLoaderBlock] == nil) {
            NSLog(@"Socialize Warning: Received direct entity notification, but no entity loader defined");
            return YES;
        }
        [self showDirectEntityNotificationForDisplay:display socializeDictionary:socializeDictionary];
        
    } else if ([notificationType isEqualToString:@"entity_notification"]) {
        if ([Socialize entityLoaderBlock] == nil) {
            NSLog(@"Socialize Warning: Received entity subscription notification, but no entity loader defined");
            return YES;
        }
        [self showDirectEntityNotificationForDisplay:display socializeDictionary:socializeDictionary];

    } else if ([notificationType isEqualToString:@"developer_notification"]) {
        // noop
    } else {
        return NO;
    }
    
    return YES;
}

@end
