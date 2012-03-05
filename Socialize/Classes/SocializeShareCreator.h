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

@class Socialize;
@protocol SocializeShareCreatorDelegate;
@protocol  SocializeShare;
@protocol SocializeEntity;
@class SocializeShareOptions;

@interface SocializeShareCreator : SocializeAction <SocializeServiceDelegate, SocializeBaseViewControllerDelegate>

+ (void)createShareWithOptions:(SocializeShareOptions*)options
                       display:(id)display
                       success:(void(^)())success
                       failure:(void(^)(NSError *error))failure;
+ (void)createShareWithOptions:(SocializeShareOptions*)options
                  displayProxy:(SocializeUIDisplayProxy*)proxy
                       success:(void(^)())success
                       failure:(void(^)(NSError *error))failure;

- (id)initWithDisplayObject:(id)displayObject
                    display:(id)display
                    options:(SocializeShareOptions*)options
                    success:(void(^)())success
                    failure:(void(^)(NSError *error))failure;

@property (nonatomic, retain) id<SocializeShare> shareObject;
@property (nonatomic, retain) SocializeShareOptions *options;
@property (nonatomic, assign) Class messageComposerClass;
@property (nonatomic, assign) Class mailComposerClass;
@property (nonatomic, retain) UIApplication *application;
@end