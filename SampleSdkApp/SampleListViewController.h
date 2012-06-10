//
//  SampleListViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kUserSection;
extern NSString *kShareSection;
extern NSString *kCommentSection;
extern NSString *kLikeSection;
extern NSString *kFacebookSection;
extern NSString *kTwitterSection;

extern NSString *kShowCommentComposerRow;
extern NSString *kShowCommentsListRow;
extern NSString *kLinkToFacebookRow;
extern NSString *kLinkToTwitterRow;

@interface SampleListViewController : UITableViewController

- (NSUInteger)indexForSectionIdentifier:(NSString*)identifier;
- (NSIndexPath*)indexPathForRowIdentifier:(NSString*)identifier;

@end
