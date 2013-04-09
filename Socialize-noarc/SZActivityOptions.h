//
//  SZActivityOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/24/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"
#import "SZSocialNetworkPostData.h"

@interface SZActivityOptions : NSObject

+ (id)defaultOptions;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL dontShareLocation;
@property (nonatomic, copy) void (^willPostToSocialNetworkBlock)(SZSocialNetwork network, NSMutableDictionary *params)  __attribute__((deprecated("Please use willAttemptPostingToSocialNetworkBlock, which allows for more complete customization")));
@property (nonatomic, copy) void (^didPostToSocialNetworkBlock)(SZSocialNetwork network) __attribute__((deprecated("Please use didSucceedPostingToSocialNetworkBlock, which allows for more complete customization")));
@property (nonatomic, copy) void (^didFailToPostToSocialNetworkBlock)(SZSocialNetwork network) __attribute__((deprecated("Please use didFailPostingToSocialNetworkBlock, which allows for more complete customization")));
@property (nonatomic, copy) void (^willAttemptPostingToSocialNetworkBlock)(SZSocialNetwork network, SZSocialNetworkPostData *postData);
@property (nonatomic, copy) void (^didSucceedPostingToSocialNetworkBlock)(SZSocialNetwork network, id result);
@property (nonatomic, copy) void (^didFailPostingToSocialNetworkBlock)(SZSocialNetwork network, NSError *error);

@end
