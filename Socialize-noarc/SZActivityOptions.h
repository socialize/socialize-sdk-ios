//
//  SZActivityOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"

@interface SZActivityOptions : NSObject

+ (SZActivityOptions*)defaultOptions;

@property (nonatomic, assign) BOOL dontShareLocation;
@property (nonatomic, copy) void (^willPostToSocialNetworkBlock)(SZSocialNetwork network, NSMutableDictionary *params);
@property (nonatomic, copy) void (^didPostToSocialNetworkBlock)(SZSocialNetwork network);
@property (nonatomic, copy) void (^didFailToPostToSocialNetworkBlock)(SZSocialNetwork network);

@end
