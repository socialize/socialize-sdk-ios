//
//  SZShareOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/17/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"
#import "SZActivityOptions.h"
#import "SZSMSShareData.h"
#import "SZEmailShareData.h"
#import "SZPinterestShareData.h"

@interface SZShareOptions : SZActivityOptions
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void (^willShowSMSComposerBlock)(SZSMSShareData *smsData);
@property (nonatomic, copy) void (^willShowEmailComposerBlock)(SZEmailShareData *emailData);
@property (nonatomic, copy) void (^willRedirectToPinterestBlock)(SZPinterestShareData *pinData);

+ (SZShareOptions*)defaultOptions;

@end