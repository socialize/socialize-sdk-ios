//
//  SZShareOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"

@interface SZShareOptions : NSObject

@property (nonatomic, assign) BOOL dontShareLocation;
@property (nonatomic, assign) SZSocialNetwork shareTo;
@property (nonatomic, copy) void (^willPostToSocialNetworkBlock)(SZSocialNetwork network);
@property (nonatomic, copy) void (^didPostToSocialNetworkBlock)(SZSocialNetwork network);

@end