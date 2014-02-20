//
//  SZSocialNetworkPostData.h
//  Socialize
//
//  Created by Nathaniel Griswold on 7/31/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZEntity;
@class SZActivityOptions;

@interface SZSocialNetworkPostData : NSObject

@property (nonatomic, retain) id<SZEntity> entity;
@property (nonatomic, retain) NSDictionary *propagationInfo;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, retain) SZActivityOptions *options;
@property (nonatomic, assign) BOOL useMultipart;
@property (nonatomic, retain) UIImage *image;

@end
