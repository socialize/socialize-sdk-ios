//
//  SZCommentOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/23/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZActivityOptions.h"

@interface SZCommentOptions : SZActivityOptions
@property (nonatomic, assign) BOOL dontSubscribeToNotifications;
@property (nonatomic, copy) NSString *text;

+ (SZCommentOptions*)defaultOptions;

@end
