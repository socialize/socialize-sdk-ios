//
//  UserHelper.h
//  Socialize
//
//  Created by David Jedeikin on 8/29/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHelper : NSObject

+ (NSString*)getDisplayName:(NSString*)userName firstName:(NSString *)firstName lastName:(NSString*)lastName;

@end
