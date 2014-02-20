//
//  SZActionBarUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZActionBar.h"

@interface SZActionBarUtils : NSObject

+ (SZActionBar*)showActionBarWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity options:(id)options;

@end
