//
//  SZShareDialogViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZShareDialogViewController.h"
#import "_SZShareDialogViewController.h"
#import "SZShareDialogViewControllerIOS6.h"
#import "UIDevice+VersionCheck.h"

@interface SZShareDialogViewController ()

@end

@implementation SZShareDialogViewController
@dynamic completionBlock;
@dynamic cancellationBlock;
@dynamic headerView;
@dynamic footerView;
@dynamic continueText;
@synthesize title = __title;
@dynamic display;
@dynamic hideTwitter;
@dynamic hideFacebook;
@dynamic hideSMS;
@dynamic hideEmail;
@dynamic hidePinterest;
@dynamic dontShowComposer;
@dynamic shareOptions;

//class cluster impl
//used for navbar as this class is a subclass of SZNavigationBar
+ (id)alloc {
    if([self class] == [SZShareDialogViewController class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
           return [SZShareDialogViewControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
        [self createShareDialog];
    }
    
    return self;
}

- (void)createShareDialog {
    self._shareDialogViewController = [[_SZShareDialogViewController alloc] initWithEntity:self.entity];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pushViewController:self._shareDialogViewController animated:NO];
}

- (void)deselectSelectedRow {
    [self._shareDialogViewController deselectSelectedRow];
}

- (void)setTitle:(NSString *)title {
    __title = title;
    [self._shareDialogViewController setTitle:title];
}

- (NSString*)title {
    return self._shareDialogViewController.title;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self._shareDialogViewController;
}

@end
