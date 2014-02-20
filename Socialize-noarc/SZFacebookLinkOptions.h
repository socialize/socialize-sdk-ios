//
//  SZFacebookLinkOptions.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFacebookLinkOptions : NSObject

+ (SZFacebookLinkOptions*)defaultOptions;

@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, copy) void (^willSendLinkRequestToSocializeBlock)();

@end
