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

//+ (void)createComment:(id<SocializComment>)comment
//          withOptions:(SocializeCommentOptions*)options
//              display:(id)display
//              success:(void(^)())success
//              failure:(void(^)(NSError *error))failure {
//    
////    SocializeCommentCreator *comment = [[[SocializeCommentCreator alloc]
////                                         initWithDisplayProxy:display activity:comment options:<#(SocializeActivityOptions *)#> success:<#^(void)success#> failure:<#^(NSError *error)failure#>
//}

- (id)initWithComment:(id<SocializeComment>)comment
              options:(SocializeActivityOptions*)options
              display:(id)display
                   success:(void(^)())success
                   failure:(void(^)(NSError *error))failure {
    
//    return [super initWithDisplayObject:nil display:<#(id)#> success:<#^(void)success#> failure:<#^(NSError *error)failure#>
//                              activity:activity
//                               options:options
//                               success:success
//                               failure:failure];
    return nil;
}

- (id<SocializeComment>)comment {
    return (id<SocializeComment>)self.activity;
}

- (NSString*)textForFacebook {
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.comment.entity];
    return [NSMutableString stringWithFormat:@"%@ \n\n %@", objectURL, self.comment.text];
}

- (NSString*)textForTwitter {
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.comment.entity];
    return [NSMutableString stringWithFormat:@"%@ (%@)", self.comment.text, objectURL];
}

- (void)createActivityOnSocializeServer {
    [self.socialize createComment:self.comment];
}

- (void)service:(SocializeService *)service didCreate:(id)objectOrObjects {
    NSAssert([objectOrObjects conformsToProtocol:@protocol(SocializeComment)], @"Not a comment");
    
    [self succeedServerCreateWithActivity:objectOrObjects];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self failWithError:error];
}

@end
