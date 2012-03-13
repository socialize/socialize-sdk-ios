//
//  SocializeActionBarDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerDelegate.h"

@class SocializeActionBar;
@protocol SocializeActionBarDelegate <SocializeBaseViewControllerDelegate>;

@optional
- (void)actionBar:(SocializeActionBar*)actionBar wantsDisplayActionSheet:(UIActionSheet*)actionSheet;

@end
