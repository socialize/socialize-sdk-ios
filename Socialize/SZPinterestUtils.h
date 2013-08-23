//
//  SZPinterestUtils.h
//  Socialize
//
//  Created by Sergey Popenko on 6/24/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZShareOptions.h"

@interface SZPinterestUtils : NSObject

+ (void) setApplicationId: (NSString*) appID;
+ (BOOL) isAvailable;

+ (void) shareViaPinterestWithViewController:(UIViewController*)viewController
                                     options:(SZShareOptions*)options
                                      entity:(id<SZEntity>)entity
                                     success:(void(^)(id<SZShare> share))success
                                     failure:(void(^)(NSError *error))failure;

@end
