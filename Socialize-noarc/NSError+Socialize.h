//
//  NSError+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/2/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeErrorDefinitions.h"

@interface NSError (Socialize)
+ (NSError*)socializeUnexpectedJSONResponseErrorWithResponse:(NSString*)responseString reason:(NSString*)reason;
+ (NSError*)socializeServerReturnedErrorsErrorWithErrorsArray:(NSArray*)errorsArray objectsArray:(NSArray*)objectsArray;
+ (NSError*)defaultSocializeErrorForCode:(NSUInteger)code;
+ (NSError*)socializeServerReturnedHTTPErrorErrorWithResponse:(NSHTTPURLResponse*)response responseBody:(NSString*)responseBody;
- (BOOL)isSocializeErrorWithCode:(SocializeErrorCode)code;
@end
