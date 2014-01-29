//
//  SocializeOSVersionTests.m
//  Socialize
//
//  Created by David Jedeikin on 1/15/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SocializeOSVersionTests.h"
#import "SZCommentsListViewController.h"
#import "SZComposeCommentViewController.h"
#import "SocializeActivityViewController.h"
#import "SZLinkDialogViewController.h"
#import "SZShareDialogViewController.h"
#import "_SZUserProfileViewController.h"
#import "CommentsTableFooterView.h"
#import "CommentsTableViewCell.h"
#import "SocializeActivityDetailsView.h"
#import "SZNavigationController.h"
#import "SZActionBar.h"
#import "SZActionButton.h"
#import "SZLikeButton.h"
#import "UIButton+Socialize.h"
#import "UIDevice+VersionCheck.h"

@implementation SocializeOSVersionTests

- (void)testSZNavigationControllerVersion {
    UIViewController *dummyController = [[UIViewController alloc] init];
    SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:dummyController];
    [self assertMatchClass:nav
             ios6ClassName:@"SZNavigationControllerIOS6"
             ios7ClassName:@"SZNavigationController"];
}

- (void)testSZCommentsListViewControllerVersion {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZCommentsListViewController *comments = [[SZCommentsListViewController alloc] initWithEntity:entity];
    [self assertMatchClass:comments
             ios6ClassName:@"SZCommentsListViewControllerIOS6"
             ios7ClassName:@"SZCommentsListViewController"];
}

- (void)testSZComposeCommentViewControllerVersion {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZComposeCommentViewController *composer = [[SZComposeCommentViewController alloc] initWithEntity:entity];
    [self assertMatchClass:composer
             ios6ClassName:@"SZComposeCommentViewControllerIOS6"
             ios7ClassName:@"SZComposeCommentViewController"];
}

- (void)testSocializeActivityViewControllerVersion {
    NSString *cellNibName = [SocializeActivityViewController tableViewCellNibName];
    NSString *matchNibName = [[UIDevice currentDevice] systemMajorVersion] < 7 ?
                             @"SocializeActivityTableViewCell" :
                             @"SocializeActivityTableViewCellIOS7";
    GHAssertEqualStrings(cellNibName, matchNibName, @"");
}

- (void)testSZLinkDialogViewControllerVersion {
    SZLinkDialogViewController *link = [[SZLinkDialogViewController alloc] init];
    [self assertMatchClass:link
             ios6ClassName:@"SZLinkDialogViewControllerIOS6"
             ios7ClassName:@"SZLinkDialogViewController"];
}

- (void)test_SZLinkDialogViewControllerVersion {
    _SZLinkDialogViewController *authViewController = [[_SZLinkDialogViewController alloc] initWithNibName:nil bundle:nil];
    [self assertMatchClass:authViewController
             ios6ClassName:@"_SZLinkDialogViewControllerIOS6"
             ios7ClassName:@"_SZLinkDialogViewController"];
    
    //test OS version-variant code
    //for UIImages, simply test they're not null unless expected
    GHAssertNotNil([authViewController facebookIcon:YES], @"");
    GHAssertNotNil([authViewController facebookIcon:NO], @"");
    GHAssertNotNil([authViewController twitterIcon:YES], @"");
    GHAssertNotNil([authViewController twitterIcon:NO], @"");
    GHAssertNotNil([authViewController callOutArrow], @"");
    GHAssertNotNil([authViewController authorizeUserIcon], @"");
}

- (void)testSZShareDialogViewControllerVersion {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZShareDialogViewController *share = [[SZShareDialogViewController alloc] initWithEntity:entity];
    [self assertMatchClass:share
             ios6ClassName:@"SZShareDialogViewControllerIOS6"
             ios7ClassName:@"SZShareDialogViewController"];
}

- (void)test_SZUserProfileViewControllerVersion {
    _SZUserProfileViewController *profileController = [[[_SZUserProfileViewController alloc] init] autorelease];
    [self assertMatchClass:profileController
             ios6ClassName:@"_SZUserProfileViewControllerIOS6"
             ios7ClassName:@"_SZUserProfileViewController"];

    //test OS version-variant code
    //for UIImages, simply test they're not nil unless expected
    GHAssertNotNil([profileController defaultBackgroundImage], @"");
    GHAssertNotNil([profileController defaultProfileBackgroundImage], @"");
    GHAssertNotNil([profileController defaultHeaderBackgroundImage], @"");
    if([[UIDevice currentDevice] systemMajorVersion] < 7) {
        GHAssertNotNil([profileController defaultProfileImage], @"");
    }
    else {
        //this is iOS 7 (_SZUserProfileViewController) expected output
        GHAssertNil([profileController defaultProfileImage], @"");
    }
}

- (void)testSZActionBarVersion {
    SZActionBar *actionBar = [[[SZActionBar alloc] initWithFrame:CGRectMake(0, 0, 1, 1) entity:nil viewController:nil] autorelease];
    [self assertMatchClass:actionBar
             ios6ClassName:@"SZActionBarIOS6"
             ios7ClassName:@"SZActionBar"];
}

- (void)testSZActionButtonVersion {
    SZActionButton *button = [SZActionButton actionButtonWithIcon:nil title:@"Action"];
    [self assertMatchClass:button
             ios6ClassName:@"SZActionButtonIOS6"
             ios7ClassName:@"SZActionButton"];

    //test OS version-variant code
    //for UIImages, simply test they're not null unless expected
    if([[UIDevice currentDevice] systemMajorVersion] < 7) {
        GHAssertNil([[button class] defaultDisabledImage], @"");
        GHAssertNotNil([[button class] defaultImage], @"");
        GHAssertNotNil([[button class] defaultHighlightedImage], @"");
    }
    else {
        GHAssertNil([[button class] defaultDisabledImage], @"");
        GHAssertNil([[button class] defaultImage], @"");
        GHAssertNil([[button class] defaultHighlightedImage], @"");
    }
}

- (void)testSZLikeButtonVersion {
    SZLikeButton *likeButtonTabStyle = [[[SZLikeButton alloc] initWithFrame:CGRectZero
                                                                     entity:nil
                                                             viewController:nil
                                                                tabBarStyle:YES] autorelease];
    [self assertMatchClass:likeButtonTabStyle
             ios6ClassName:@"SZLikeButtonIOS6"
             ios7ClassName:@"SZLikeButton"];

    //test OS version-variant code
    //for UIImages, simply test they're not null unless expected
    if([[UIDevice currentDevice] systemMajorVersion] < 7) {
        GHAssertNotNil([[likeButtonTabStyle class] defaultDisabledImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultInactiveImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultInactiveHighlightedImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultNonTabBarInactiveImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultNonTabBarInactiveHighlightedImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultActiveImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultActiveHighlightedImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultLikedIcon] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultUnlikedIcon] ,@"");
    }
    else {
        GHAssertNil([[likeButtonTabStyle class] defaultDisabledImage] ,@"");
        GHAssertNil([[likeButtonTabStyle class] defaultInactiveImage] ,@"");
        GHAssertNil([[likeButtonTabStyle class] defaultInactiveHighlightedImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultNonTabBarInactiveImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultNonTabBarInactiveHighlightedImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultActiveImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultActiveHighlightedImage] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultLikedIcon] ,@"");
        GHAssertNotNil([[likeButtonTabStyle class] defaultUnlikedIcon] ,@"");
    }
}

- (void)testCommentsTableFooterViewVersion {
    CommentsTableFooterView *actionBar = [[CommentsTableFooterView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self assertMatchClass:actionBar
             ios6ClassName:@"CommentsTableFooterViewIOS6"
             ios7ClassName:@"CommentsTableFooterView"];

    //test OS version-variant code
    //for UIImages, simply test they're not null unless expected
    GHAssertNotNil([actionBar searchBarImage], @"");
    GHAssertNotNil([actionBar backgroundImage], @"");
}

- (void)testCommentsTableViewCellVersion {
    CommentsTableViewCell *cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:@"cell"];
    [self assertMatchClass:cell
             ios6ClassName:@"CommentsTableViewCellIOS6"
             ios7ClassName:@"CommentsTableViewCell"];
    
    NSString *cellNibName = [CommentsTableViewCell nibName];
    NSString *matchNibName = [[UIDevice currentDevice] systemMajorVersion] < 7 ?
                             @"CommentsTableViewCell" :
                             @"CommentsTableViewCellIOS7";
    GHAssertEqualStrings(cellNibName, matchNibName, @"");

    if([[UIDevice currentDevice] systemMajorVersion] < 7) {
        GHAssertNotNil([cell defaultBackgroundImage], @"");
        GHAssertNotNil([cell defaultProfileImage], @"");
    }
    else {
        GHAssertNil([cell defaultBackgroundImage], @"");
        GHAssertNotNil([cell defaultProfileImage], @"");
    }
}

- (void)testSocializeActivityDetailsViewVersion {
    SocializeActivityDetailsView *activityDetailsView = [[SocializeActivityDetailsView alloc] init];
    [self assertMatchClass:activityDetailsView
             ios6ClassName:@"SocializeActivityDetailsViewIOS6"
             ios7ClassName:@"SocializeActivityDetailsView"];
}

- (void)testUIButtonVersion {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self assertMatchClass:button
             ios6ClassName:@"UIButtonIOS6"
             ios7ClassName:@"UIButton"];
}

//convenience method
- (void)assertMatchClass:(NSObject *)obj ios6ClassName:(NSString *)ios6Name ios7ClassName:(NSString *)ios7Name {
    NSString *className = NSStringFromClass([obj class]);
    NSString *matchClassName = [[UIDevice currentDevice] systemMajorVersion] < 7 ? ios6Name : ios7Name;
    GHAssertEqualStrings(className, matchClassName, @"");
    NSLog(@"OS-specific classname: %@", className);
}

@end
