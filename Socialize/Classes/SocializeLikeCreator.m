//
//  SocializeLikeCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeCreator.h"
#import "_Socialize.h"

@implementation SocializeLikeCreator

+ (void)createLike:(id<SocializeLike>)like
           options:(SocializeLikeOptions*)options
      displayProxy:(SocializeUIDisplayProxy*)displayProxy
           success:(void(^)(id<SocializeLike>))success
           failure:(void(^)(NSError *error))failure {
    
    SocializeLikeCreator *creator = [[[SocializeLikeCreator alloc] initWithActivity:like
                                                                            options:options
                                                                       displayProxy:displayProxy
                                                                            display:nil] autorelease];
    creator.activitySuccessBlock = success;
    creator.failureBlock = failure;
    [SocializeAction executeAction:creator];
}

- (id<SocializeLike>)like {
    return (id<SocializeLike>)self.activity;
}

- (NSString*)textForFacebook {
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.like.entity];
    NSMutableString* message = [NSMutableString stringWithFormat:@"Liked %@", objectURL];
    
    return message;
}

- (void)createActivityOnSocializeServer {
    [self.socialize createLike:self.like];
}

- (void)service:(SocializeService *)service didCreate:(id)objectOrObjects {
    NSAssert([objectOrObjects conformsToProtocol:@protocol(SocializeLike)], @"Not a like");
    
    [self succeedServerCreateWithActivity:objectOrObjects];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self failServerCreateWithError:error];
}

@end
