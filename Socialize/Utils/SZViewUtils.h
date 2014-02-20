//
//  SZViewUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/5/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

@interface SZViewUtils : NSObject

+ (void)viewEntity:(id<SZEntity>)entity success:(void(^)(id<SZView> view))success failure:(void(^)(NSError *error))failure;

@end