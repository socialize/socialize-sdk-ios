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

@interface SZShareOptions : SZActivityOptions
@property (nonatomic, copy) NSString *text;

+ (SZShareOptions*)defaultOptions;

@end