//
//  SZUserSettingsViewControllerViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZUserSettingsViewController.h"
#import "_SZUserSettingsViewController.h"
#import "SZUserSettingsViewControllerIOS6.h"
#import "UIDevice+VersionCheck.h"

@interface SZUserSettingsViewController ()
@property (nonatomic, assign) BOOL initialized;
@property (nonatomic, strong) _SZUserSettingsViewController *settings;
@end

@implementation SZUserSettingsViewController
@synthesize completionBlock = _completionBlock;
@synthesize initialized = _initialized;
@synthesize settings = _settings;
@dynamic hideLogoutButtons;

//class cluster impl
//used for navbar as this class is a subclass of SZNavigationBar
+ (id)alloc {
    if([self class] == [SZUserSettingsViewController class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [SZUserSettingsViewControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializeIfNeeded];
}

- (_SZUserSettingsViewController*)settings {
    if (_settings == nil) {
        _settings = [[_SZUserSettingsViewController alloc] init];
    }
    return _settings;
}

- (void)initializeIfNeeded {
    if (!self.initialized) {
        [self pushViewController:self.settings animated:NO];
        self.initialized = YES;
    }
}

- (void)setCompletionBlock:(void (^)(BOOL, id<SocializeFullUser>))completionBlock {
    self.settings.userSettingsCompletionBlock = completionBlock;
    _completionBlock = [completionBlock copy];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.settings;
}

@end
