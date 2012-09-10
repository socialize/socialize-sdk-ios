//
//  UIViewController+Display.h
//  Socialize
//
//  Created by Nathaniel Griswold on 9/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZDisplay.h"
#import "SocializeLoadingView.h"

@interface UIViewController (Display) <SZDisplay>
@property (nonatomic, strong) SocializeLoadingView *loadingView;

@end
