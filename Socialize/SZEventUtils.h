//
//  SZEventUtils.h
//  Socialize
//
//  Created by Nathaniel Griswold on 9/7/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

@interface SZEventUtils : NSObject

+ (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;

@end
