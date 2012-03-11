//
//  SocializeShareCreator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/21/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeServiceDelegate.h"
#import "SocializeAction.h"
#import "SocializeBaseViewControllerDelegate.h"
#import "SocializeUIShareOptions.h"

@class Socialize;
@protocol SocializeShareCreatorDelegate;
@protocol  SocializeShare;
@protocol SocializeEntity;

@interface SocializeUIShareCreator : SocializeAction <SocializeServiceDelegate, SocializeBaseViewControllerDelegate>

+ (void)createShareWithOptions:(SocializeUIShareOptions*)options
                       display:(id)display
                       success:(void(^)())success
                       failure:(void(^)(NSError *error))failure;
+ (void)createShareWithOptions:(SocializeUIShareOptions*)options
                  displayProxy:(SocializeUIDisplayProxy*)proxy
                       success:(void(^)())success
                       failure:(void(^)(NSError *error))failure;

@property (nonatomic, retain) id<SocializeShare> shareObject;
@property (nonatomic, retain) SocializeUIShareOptions *options;
@property (nonatomic, assign) Class messageComposerClass;
@property (nonatomic, assign) Class mailComposerClass;
@property (nonatomic, retain) UIApplication *application;
@end