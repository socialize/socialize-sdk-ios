//
//  SZOARequest.h
//  Socialize
//
//  Created by Nathaniel Griswold on 7/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OAuthConsumer/OAuthConsumer.h>

@interface SZOARequest : NSOperation

- (id)initWithConsumerKey:(NSString*)consumerKey
           consumerSecret:(NSString*)consumerSecret
                    token:(NSString*)token
              tokenSecret:(NSString*)tokenSecret
                   method:(NSString*)method
                   scheme:(NSString*)scheme
                     host:(NSString*)host
                     path:(NSString*)path
               parameters:(NSDictionary*)parameters
                multipart:(BOOL)multipart
                  success:(void(^)(NSURLResponse*, NSData *data))success
                  failure:(void(^)(NSError *error))failure;

@property (nonatomic, copy) void (^successBlock)(NSURLResponse *response, NSData *data);
@property (nonatomic, copy) void (^failureBlock)(NSError *error);
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;

- (void)start;
- (void)cancel;

@end
