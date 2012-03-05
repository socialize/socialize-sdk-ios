//
//  SocializeUIDisplayTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeUIDisplayProxy.h"

@interface SocializeUIDisplayTests : NSObject
@property (nonatomic, retain) SocializeUIDisplayProxy *displayProxy;
@property (nonatomic, retain) id mockHandler;
@property (nonatomic, retain) id mockDisplay;
@end
