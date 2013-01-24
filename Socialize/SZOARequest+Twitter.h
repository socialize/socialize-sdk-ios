//
//  SZOARequest+Twitter.h
//  Socialize
//
//  Created by Nathaniel Griswold on 7/12/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequest.h"

@interface SZOARequest (Twitter)

+ (SZOARequest*)twitterRequestWithMethod:(NSString*)method
                                    path:(NSString*)path
                              parameters:(NSDictionary*)parameters
                                 success:(void(^)(id result))success
                                 failure:(void(^)(NSError *error))failure;

+ (SZOARequest*)twitterRequestWithMethod:(NSString*)method
                                    path:(NSString*)path
                              parameters:(NSDictionary*)parameters
                               multipart:(BOOL)multipart
                                 success:(void(^)(id result))success
                                 failure:(void(^)(NSError *error))failure;

@end
