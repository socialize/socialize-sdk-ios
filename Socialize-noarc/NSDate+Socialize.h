//
//  NSDate+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Socialize)
+ (NSDate*)dateWithSocializeDateString:(NSString*)socializeDateString;
@end
