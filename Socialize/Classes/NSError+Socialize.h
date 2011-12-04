//
//  NSError+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/2/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Socialize)
+ (NSError*)socializeUnexpectedJSONResponseErrorWithResponse:(NSString*)responseString description:(NSString*)description;
+ (NSError*)socializeServerReturnedErrorsErrorWithErrorsArray:(NSArray*)errorsArray;
+ (NSError*)defaultSocializeErrorForCode:(NSUInteger)code;
+ (NSError*)socializeServerReturnedHTTPErrorErrorWithResponse:(NSHTTPURLResponse*)response responseBody:(NSString*)responseBody;
@end
