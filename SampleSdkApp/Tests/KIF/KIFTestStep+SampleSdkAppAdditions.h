//
//  KIFTestStep+SampleAdditions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (SampleSdkAppAdditions)

+ (NSArray*)stepsToReturnToList;
+ (NSString *)getRandomURL;
+ (NSArray*)stepsToShowTabbedActionBarForURL:(NSString*)url;
+ (NSArray*)stepsToLikeOnActionBar;
+ (NSArray*)stepsToCommentOnActionBar;
+ (NSArray*)stepsToCreateEntityWithURL:(NSString*)url name:(NSString*)name;
+ (NSArray*)stepsToCreateEntityWithRandomURL;
+ (NSArray*)stepsToGetEntityWithURL:(NSString*)url;
+ (NSArray*)stepsToSkipAuth;
+ (id)stepToExecuteBlock:(void (^)())block;
+ (NSArray*)stepsToGetCommentsForEntity:(NSString*)entity;
+ (NSArray*)stepsToLikeEntity:(NSString*)entity;
+ (NSArray*)stepsToVerifyLikesForEntity:(NSString*)entity areAtCount:(NSInteger)count;
+ (NSArray*)stepsToUnlikeEntity:(NSString*)entity;
+ (NSArray*)stepsToWaitForActionCompleted;
+ (NSArray*)stepsToViewEntityWithURL:(NSString*)url;
+ (NSArray*)stepsToVerifyViewsForEntity:(NSString*)entity areAtCount:(NSInteger)count;
+ (NSArray*)stepsToCreateCommentWithControllerForEntity:(NSString*)entity comment:(NSString*)comment;
+ (NSArray*)stepsToCreateComment:(NSString*)comment;
+ (NSArray*)stepsToVerifyCommentExistsForEntity:(NSString*)entity comment:(NSString*)comment;
+ (NSArray*)stepsToShowButtonTestController:(NSString*)url;
+ (id)stepToScrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;
+ (id)stepToCheckAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue;
+ (NSArray*)stepsToVerifyActionBarViewsAtCount:(NSInteger)count;
+ (id)stepToVerifyViewWithAccessibilityLabel:(NSString*)label passesTest:(BOOL (^)(id view))testBlock;
+ (NSArray*)stepsToVerifyActionBarLikesAtCount:(NSInteger)count;
+ (id)stepToVerifyElementWithAccessibilityLabelDoesNotExist:(NSString*)label;
//+ (id)stepToVerifyFacebookFeedContainsMessage:(NSString*)message;
+ (NSArray*)stepsToCreateShare:(NSString*)comment;
+ (NSArray*)stepsToOpenProfile;
+ (NSArray*)stepsToOpenEditProfile;
+ (NSArray*)stepsToEditProfileImage;
+ (NSArray*)stepsToSetProfileFirstName:(NSString*)firstName;
+ (NSArray*)stepsToVerifyProfileFirstName:(NSString*)firstName;
+ (id)stepToWipeAuthenticationInfo;
+ (id)stepToNoCheckEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
+ (id)stepToScrollScrollViewWithAccessibilityLabel:(NSString*)scrollViewLabel toViewWithAcccessibilityLabel:(NSString*)viewLabel;
+ (id)stepToScrollTableViewWithAccessibilityLabel:(NSString*)label toRowAtIndexPath:(NSIndexPath*)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
@end
