//
//  SampleListViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>

extern NSString *kUserSection;
extern NSString *kShareSection;
extern NSString *kCommentSection;
extern NSString *kLikeSection;
extern NSString *kFacebookSection;
extern NSString *kTwitterSection;
extern NSString *kSmartAlertsSection;
extern NSString *kActionBarSection;

extern NSString *kShowLinkDialogRow;
extern NSString *kShowUserProfileRow;
extern NSString *kShowCommentComposerRow;
extern NSString *kShowCommentsListRow;
extern NSString *kLinkToFacebookRow;
extern NSString *kLinkToTwitterRow;
extern NSString *kPostToTwitterRow;
extern NSString *kShareImageToTwitterRow;
extern NSString *kLikeEntityRow;
extern NSString *kShowShareRow;
extern NSString *kHandleDirectURLSmartAlertRow;
extern NSString *kShowActionBarExampleRow;
extern NSString *kShowButtonsExampleRow;

@interface TestAppListViewController : UITableViewController
@property (nonatomic, retain) id<SZEntity> entity;

+ (TestAppListViewController*)sharedSampleListViewController;
- (NSUInteger)indexForSectionIdentifier:(NSString*)identifier;
- (NSIndexPath*)indexPathForRowIdentifier:(NSString*)identifier;

@end
