//
//  SZWindowDisplay.h
//  Socialize
//
//  Created by Nathaniel Griswold on 9/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZDisplay.h"
#import "SocializeLoadingView.h"

@interface SZWindowDisplay : NSObject <SZDisplay>
+ (SZWindowDisplay*)sharedWindowDisplay;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) SocializeLoadingView *loadingView;
@end
