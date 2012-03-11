//
//  NSString+NSString_Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocializeObject;
@protocol SocializeEntity;

@interface NSString (Socialize)
+(NSString *) stringWithHumanReadableIntegerAndSuffixSinceDate:(NSDate *)date;

+ (NSString*)socializeRedirectURL:(NSString*)path;
+ (NSString*)stringWithSocializeURLForObject:(id<SocializeObject>)object;
+ (NSString*)stringWithSocializeURLForApplication;
+ (NSString*)stringWithTitleForSocializeEntity:(id<SocializeEntity>)entity;
+ (NSString*)stringWithSocializeAppDownloadPlug;

@end
