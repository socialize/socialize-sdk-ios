//
//  SZActionBarDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerDelegate.h"

@class SZActionBar;
@protocol SZActionBarDelegate <SocializeBaseViewControllerDelegate>;

@optional
- (void)actionBar:(SZActionBar*)actionBar wantsDisplayActionSheet:(UIActionSheet*)actionSheet;

@end
