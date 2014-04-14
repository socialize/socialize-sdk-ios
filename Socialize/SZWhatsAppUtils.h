//
//  SZWhatsAppUtils.h
//  Socialize
//
//  Created by David Jedeikin on 4/7/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZShareOptions.h"

@interface SZWhatsAppUtils : NSObject<UIAlertViewDelegate>

+ (void) setShowInShare:(BOOL)show;
+ (BOOL) isAvailable;
+ (void) shareViaWhatsAppWithViewController:(UIViewController*)viewController
                                    options:(SZShareOptions*)options
                                     entity:(id<SZEntity>)entity
                                    success:(void(^)(id<SZShare> share))success
                                    failure:(void(^)(NSError *error))failure;

@end
