//
//  NSError+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/2/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Socialize)
+ (NSError*)socializeUnexpectedJSONResponseErrorForResponse:(NSString*)responseString;
+ (NSError*)defaultSocializeErrorForCode:(NSUInteger)code;
@end
