//
//  SocializePostShareViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewController.h"
#import "SocializeComposeMessageViewController.h"

@class SocializeShareBuilder;

@interface SocializePostShareViewController : SocializeComposeMessageViewController
+ (UINavigationController*)postShareViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL;
+ (SocializePostShareViewController*)postShareViewControllerWithEntityURL:(NSString*)entityURL;

@property (nonatomic, retain) id<SocializeActivity> shareObject;

- (void)sendButtonPressed:(UIButton*)button;
@end
