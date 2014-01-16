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
}

- (void)testCommentsTableFooterViewVersion {
    CommentsTableFooterView *actionBar = [[CommentsTableFooterView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self assertMatchClass:actionBar
             ios6ClassName:@"CommentsTableFooterViewIOS6"
             ios7ClassName:@"CommentsTableFooterView"];
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

- (void)assertMatchClass:(NSObject *)obj ios6ClassName:(NSString *)ios6Name ios7ClassName:(NSString *)ios7Name {
    NSString *className = NSStringFromClass([obj class]);
    NSString *matchClassName = [[UIDevice currentDevice] systemMajorVersion] < 7 ? ios6Name : ios7Name;
    GHAssertEqualStrings(className, matchClassName, @"");
    NSLog(@"OS-specific classname: %@", className);
}

@end
