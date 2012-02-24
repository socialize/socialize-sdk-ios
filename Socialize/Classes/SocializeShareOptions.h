//
//  SocializeShareOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/25/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocializeEntity;
@class SocializeFacebookAuthOptions;
@class SocializeTwitterAuthOptions;

@interface SocializeShareOptions : NSObject

+ (id)shareOptionsWithEntity:(id<SocializeEntity>)entity;

- (id)initWithEntity:(id<SocializeEntity>)entity;

@property (nonatomic, retain) id<SocializeEntity> entity;
@property (nonatomic, retain) SocializeFacebookAuthOptions *facebookAuthOptions;
@property (nonatomic, retain) SocializeTwitterAuthOptions *twitterAuthOptions;

@end
