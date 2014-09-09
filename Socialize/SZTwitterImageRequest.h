//
//  SZSTTwitterRequest.h
//  Socialize
//
//  Created by David Jedeikin on 9/9/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter/STTwitter.h>

@interface SZTwitterImageRequest : NSOperation

@property (nonatomic, copy) void (^successBlock)(id result);
@property (nonatomic, copy) void (^failureBlock)(NSError *error);
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;

+ (SZTwitterImageRequest *)twitterRequestWithMethod:(NSString*)method
                                      parameters:(NSDictionary*)parameters
                                         success:(void(^)(id result))success
                                         failure:(void(^)(NSError *error))failure;
- (id)initWithConsumerKey:(NSString*)consumerKey
           consumerSecret:(NSString*)consumerSecret
                    token:(NSString*)token
              tokenSecret:(NSString*)tokenSecret
               parameters:(NSDictionary*)parameters
                  success:(void(^)(id result))success
                  failure:(void(^)(NSError *error))failure;
- (void)start;
- (void)cancel;

@end
