//
//  SocializeAction.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeServiceDelegate.h"

@class Socialize;
@class SocializeUIDisplay;

@interface SocializeAction : NSObject <SocializeServiceDelegate>
- (id)initWithDisplayHandler:(id)displayHandler;
- (void)cancelAllCallbacks;

@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) SocializeUIDisplay *display;
@end
