//
//  SocializeDirectEntityNotificationDisplayController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeDirectEntityNotificationDisplayController.h"
#import "SocializeDummyViewController.h"
#import "socialize_globals.h"

@interface SocializeDirectEntityNotificationDisplayController ()
@property (nonatomic, assign) BOOL loadComplete;
@end

@implementation SocializeDirectEntityNotificationDisplayController
@synthesize navigationController = navigationController_;
@synthesize dummyController = dummyController_;
@synthesize socialize = socialize_;
@synthesize entity = entity_;

@synthesize loadComplete = loadComplete_;

- (void)dealloc {
    self.navigationController = nil;
    self.dummyController = nil;
    self.socialize = nil;
    self.entity = nil;
    
    [super dealloc];
}

- (id)initWithUserInfo:(NSDictionary *)userInfo {
    if (self = [super initWithUserInfo:userInfo]) {
        
    }
    return self;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (UIViewController*)mainViewController {
    return self.navigationController;
}

- (SocializeDummyViewController*)dummyController {
    if (dummyController_ == nil) {
        dummyController_ = [[SocializeDummyViewController alloc] init];
        dummyController_.delegate = self;
    }
    
    return dummyController_;
}

- (UINavigationController*)navigationController {
    if (navigationController_ == nil) {
        navigationController_ = [[UINavigationController socializeNavigationControllerWithRootViewController:self.dummyController] retain];
        navigationController_.delegate = self;
    }
    
    return navigationController_;
}

- (void)dismiss {
    [self.delegate notificationDisplayControllerDidFinish:self];    
}

- (void)baseViewControllerDidFinish:(SocializeBaseViewController *)baseViewController {
    [self dismiss];
}

- (void)loadEntity {
    NSNumber *entityId = [[self.userInfo objectForKey:@"socialize"] objectForKey:@"entity_id"];
    
    if (entityId != nil) {
        [self.dummyController startLoading];
        [self.socialize getEntityWithId:entityId];
    } else {
        [self dismiss];
    }
}

- (void)receiveEntity:(id<SocializeEntity>)entity {
    self.entity = entity;
    [self.dummyController stopLoading];
    self.loadComplete = YES;
    if ([Socialize canLoadEntity:entity]) {
        [Socialize entityLoaderBlock](self.navigationController, entity);
    } else {
        [self dismiss];
    }
}

- (void)viewWasAdded {
    [self loadEntity];
}

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    if ([dataArray count] > 0) {
        [self receiveEntity:(id<SocializeEntity>)[dataArray objectAtIndex:0]];
    } else {
        [self dismiss];
    }
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self dismiss];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self.dummyController && self.loadComplete) {
        [self dismiss];
    }
}

@end
