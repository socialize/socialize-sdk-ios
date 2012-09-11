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

static SZNotificationHandler *sharedNotificationHandler;

@interface SZNotificationHandler ()
@property (nonatomic, strong) id<SZDisplay> defaultDisplay;
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
    [self.defaultDisplay dismissToViewController:nil animated:YES completion:nil];
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

- (id<SZDisplay>)defaultDisplay {
    if (_defaultDisplay == nil) {
        _defaultDisplay = [[SZWindowDisplay alloc] init];
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
    }
    
    [display startLoadingForContext:loadingContext];
    
    [SZEntityUtils getEntitiesWithIds:@[ entityId ] success:^(NSArray *entities) {
        [display stopLoadingForContext:loadingContext];
        
        id<SZEntity> entity = [entities lastObject];
        if (![Socialize canLoadEntity:entity]) {
            NSLog(@"Socialize Warning: canLoadEntity returned NO for entity in received notification");
            return;
        }
        
        SZNavigationController *navigationController = [[SZNavigationController alloc] init];
        [Socialize entityLoaderBlock](navigationController, entity);
        UIViewController *loaderController = [navigationController topViewController];
        
        if (loaderController.navigationItem.leftBarButtonItem == nil) {
            loaderController.navigationItem.leftBarButtonItem = [UIBarButtonItem blueSocializeBarButtonWithTitle:@"Done" handler:^(id sender) {
                [display dismissToViewController:nil animated:YES completion:nil];
            }];
        }
        
        [display presentViewController:navigationController fromViewController:nil animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        [display stopLoadingForContext:loadingContext];
        [display failWithError:error];
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
    if ([self displayBlock] != nil) {
        display = [self displayBlock]();
    }
    
    if (display == nil) {
        display = self.defaultDisplay;
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
        
        [display startLoadingForContext:SZLoadingContextFetchingCommentForNewCommentsNotification];
        
        [SZCommentUtils getCommentsWithIds:@[ activityID ] success:^(NSArray *comments) {
            id<SZComment> comment = [comments lastObject];
            if (comment == nil) {
                NSLog(@"Socialize Warning: Did not find comment for new_comments notification");
                return;
            }
            
            [display stopLoadingForContext:SZLoadingContextFetchingCommentForNewCommentsNotification];

            SZCommentsListViewController *commentsList = [[SZCommentsListViewController alloc] initWithEntity:comment.entity];
            
            commentsList.completionBlock = ^{
                [display dismissToViewController:nil animated:YES completion:nil];
            };
            
            commentsList._commentsListViewController.showNotificationHintOnAppear = YES;

            SocializeActivityDetailsViewController *details = [[SocializeActivityDetailsViewController alloc] initWithActivity:comment];
            [commentsList pushViewController:details animated:YES];
            
            [display presentViewController:commentsList fromViewController:nil animated:YES completion:nil];

        } failure:^(NSError *error) {
            [display failWithError:error];
            [display stopLoadingForContext:SZLoadingContextFetchingCommentForNewCommentsNotification];
        }];
    } else if ([notificationType isEqualToString:@"developer_direct_url"]) {
        SocializeRichPushNotificationViewController *richPush = [[SocializeRichPushNotificationViewController alloc] init];
        richPush.title = [socializeDictionary objectForKey:@"title"];
        richPush.url = [socializeDictionary objectForKey:@"url"];
        richPush.completionBlock = ^{
            [display dismissToViewController:nil animated:YES completion:nil];
        };
        richPush.cancellationBlock = ^{
            [display dismissToViewController:nil animated:YES completion:nil];
        };

        SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:richPush];
        [display presentViewController:nav fromViewController:nil animated:YES completion:nil];
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
