//
//  SZDisplay.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/30/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SZLoadingContext {
    SZLoadingContextFetchingEntityForDirectEntityNotification,
    SZLoadingContextFetchingEntityForEntitySubscriptionNotification,
    SZLoadingContextFetchingCommentForNewCommentsNotification,
} SZLoadingContext;

typedef enum SZStatusContext {
    SZStatusContextCommentPostSucceeded,
    SZStatusContextSocializeShareCompleted,
} SZStatusContext;

@protocol SZDisplay <NSObject>

- (void)socializeRequiresPresentationOfViewController:(UIViewController*)v fromViewController:(UIViewController*)u animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)socializeRequiresDismissalToViewController:(UIViewController*)viewController animated:(BOOL)flag completion:(void (^)(void))completion;
//- (void)socializeRequiresTransitionToViewController:(UIViewController*)v fromViewController:(UIViewController*)u animated:(BOOL)flag completion:(void (^)(void))completion;

- (void)socializeRequiresIndicationOfStatusForContext:(SZStatusContext)context;
- (void)socializeDidStartLoadingForContext:(SZLoadingContext)context;
- (void)socializeDidStopLoadingForContext:(SZLoadingContext)context;
- (void)socializeRequiresIndicationOfFailureForError:(NSError*)error;

@end