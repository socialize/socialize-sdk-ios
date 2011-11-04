//
//  SocializeRecommendService.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//
#import "SocializeService.h"
#import "SocializeLike.h"

@interface SocializeRecommendService : SocializeService

-(NSDictionary *) getLikeRecommendation:(SocializeLike *)like;
@end
