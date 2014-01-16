//
//  SocializeOSVersionTests.m
//  Socialize
//
//  Created by David Jedeikin on 1/15/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SocializeOSVersionTests.h"
#import "SZCommentsListViewController.h"
#import "SZNavigationController.h"
#import "SZActionBar.h"
#import "SZActionButton.h"
#import "UIButton+Socialize.h"
#import "UIDevice+VersionCheck.h"

@implementation SocializeOSVersionTests

- (void)testSZNavigationControllerVersion {
    
}

- (void)testSZCommentsListViewControllerVersion {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZCommentsListViewController *comments = [[SZCommentsListViewController alloc] initWithEntity:entity];
    [self assertMatchClass:comments
             ios6ClassName:@"SZCommentsListViewControllerIOS6"
             ios7ClassName:@"SZCommentsListViewController"];
}

- (void)testSZComposeCommentViewControllerVersion {
    
}

- (void)testSocializeActivityViewControllerVersion {
    
}

- (void)testSZLinkDialogViewControllerVersion {
    
}

- (void)test_SZLinkDialogViewControllerVersion {
    
}

- (void)testSZShareDialogViewControllerVersion {
    
}

- (void)test_SZUserProfileViewControllerVersion {
    
}

- (void)testSZActionBarVersion {
    
}

- (void)testSZActionButtonVersion {
    
}

- (void)testCommentsTableFooterViewVersion {
    
}

- (void)testCommentsTableViewCellVersion {
    
}

- (void)testSocializeActivityDetailsViewVersion {
    
}

- (void)testUIButtonVersion {
    
}

- (void)assertMatchClass:(NSObject *)obj ios6ClassName:(NSString *)ios6Name ios7ClassName:(NSString *)ios7Name {
    NSString *className = NSStringFromClass([obj class]);
    NSString *matchClassName = [[UIDevice currentDevice] systemMajorVersion] < 7 ? ios6Name : ios7Name;
    GHAssertEqualStrings(className, matchClassName, @"");
}

@end
