//
//  NSString+NSString_Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Socialize)
+(NSString *) stringWithHumanReadableIntegerAndSuffixSinceDate:(NSDate *)date;
@end
