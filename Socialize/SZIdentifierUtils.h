//
//  SZIdentifierUtils.h
//  Socialize
//
//  Created by David Jedeikin on 4/30/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>

@interface SZIdentifierUtils : NSObject

+ (NSString *)identifierString;
+ (NSString *)base64IdentifierString;

@end
