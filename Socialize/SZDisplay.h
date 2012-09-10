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

- (void)presentViewController:(UIViewController *)viewControllerToPresent fromViewController:(UIViewController*)viewController animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissToViewController:(UIViewController*)viewController animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)showStatusUpdateForContext:(SZStatusContext)context;
- (void)startLoadingForContext:(SZLoadingContext)context;
- (void)stopLoadingForContext:(SZLoadingContext)context;
- (void)failWithError:(NSError*)error;

@end