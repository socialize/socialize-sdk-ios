//
//  KIFUITestActor+TestApp.h
//  Socialize
//
//  Created by Sergey Popenko on 9/23/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <KIF/KIF.h>

@interface KIFUITestActor (TestApp)
- (void)verifyActionBarLikesAtCount:(NSInteger)count;
- (void)rotateDevice;
- (void)openLinkDialogExample;
- (void)openActionBarExample;
- (void)showUserProfile;
- (void)openEditProfile;
- (void)showButtonExample;
- (void)showLinkToFacebook;
- (void)wipeAuthData;
- (void)showLinkToTwitter;
- (void)showShareImageToTwitter;
- (void)showLikeEntityRow;
- (void)showShareDialog;
- (void)showDirectUrlNotifications;
- (void)showCommentComposer;
- (void)showCommentsList;
- (void)openSocializeDirectURLNotificationWithURL:(NSString*)url;
@end


@interface KIFUITestActor (Utils)
- (void)initializeTest;
- (void)authWithTwitter;
- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;
- (void)scrollTableViewWithAccessibilityLabel:(NSString*)label toRowAtIndexPath:(NSIndexPath*)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)noCheckEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
@end