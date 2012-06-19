//
//  SocializeLike.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeActivity.h"
#import "SocializeApplication.h"
#import "SocializeUser.h"
#import "SocializeEntity.h"

/**
 Protocol for socialize like representation.
 */
@protocol SocializeLike <SocializeActivity>
@end

/**Private implenetation of <SocializeLike> protocol*/
@interface SocializeLike : SocializeActivity <SocializeLike>

+ (SocializeLike*)likeWithEntity:(id<SocializeEntity>)entity;

@end
