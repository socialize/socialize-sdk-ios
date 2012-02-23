//
//  SocializeAction.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeUIDisplayHandler.h"

@interface SocializeUIDisplay : NSObject
/** Informal SocializeActionDisplayHandler */
@property (nonatomic, assign) id displayHandler;

+ (id)UIDisplayWithDisplayHandler:(id)displayHandler;
- (id)initWithDisplayHandler:(id)displayHandler;
- (void)displayController:(UIViewController*)controller;
- (void)dismissController:(UIViewController*)controller;
- (void)displayActionSheet:(UIActionSheet*)actionSheet;
@end
