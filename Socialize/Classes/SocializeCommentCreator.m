//
//  SocializeCommentCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeCommentCreator.h"
#import "_Socialize.h"
#import "SocializeUIDisplayProxy.h"

@implementation SocializeCommentCreator
@synthesize comment = comment_;

+ (void)createComment:(id<SocializeComment>)comment
              options:(SocializeCommentOptions*)options
              display:(id)display
              success:(void(^)(id<SocializeComment>))success
              failure:(void(^)(NSError *error))failure {
    
    SocializeCommentCreator *creator = [[[SocializeCommentCreator alloc] initWithActivity:comment
                                                                                  options:options
                                                                             displayProxy:nil
                                                                                  display:display] autorelease];
    creator.activitySuccessBlock = success;
    creator.failureBlock = failure;
    [SocializeAction executeAction:creator];
}

- (id<SocializeComment>)comment {
    return (id<SocializeComment>)self.activity;
}

- (NSString*)textForFacebook {
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.comment.entity];
    return [NSMutableString stringWithFormat:@"%@ \n\n %@", objectURL, self.comment.text];
}

- (void)createActivityOnSocializeServer {
    [self.socialize createComment:self.comment];
}

- (void)service:(SocializeService *)service didCreate:(id)objectOrObjects {
    NSAssert([objectOrObjects conformsToProtocol:@protocol(SocializeComment)], @"Not a comment");
    
    [self succeedServerCreateWithActivity:objectOrObjects];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self failServerCreateWithError:error];
}

@end
