//
//  TestAppHelper.h
//  Socialize
//
//  Created by Sergey Popenko on 9/23/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestAppHelper : NSObject
+ (NSString*)testURL:(NSString*)suffix;
+ (NSString*)runID;
+ (void)enableValidFacebookSession;
+ (void)disableValidFacebookSession;
@end
