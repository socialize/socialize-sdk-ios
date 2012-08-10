//
//  SZOARequest+Socialize.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequest.h"

@interface SZOARequest (Socialize)

+ (SZOARequest*)socializeRequestWithMethod:(NSString*)method
                                      path:(NSString*)path
                                parameters:(NSDictionary*)parameters
                                   success:(void(^)(id result))success
                                   failure:(void(^)(NSError *error))failure;

@end
