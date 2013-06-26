//
//  SZPinterestEngine.h
//  Socialize
//
//  Created by Sergey Popenko on 6/24/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZShare;

@interface SZPinterestEngine : NSObject

- (BOOL) isAvailable;
- (BOOL) handleOpenURL: (NSURL*)url;
- (void) setApplicationId: (NSString*) appID;

- (void) share:(NSString*) message imageURL:(NSURL*) imageUrl sourceUrl:(NSURL*)sourceUrl
       success:(void(^)())success
       failure:(void(^)())failure;

+ (SZPinterestEngine*) sharedInstance;

@end
