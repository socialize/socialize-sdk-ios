//
//  SocializeFacebookWallPoster.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookWallPoster.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeFacebookAuthenticator.h"
#import "_Socialize.h"

@interface SocializeFacebookWallPoster ()
@property (nonatomic, assign) BOOL sentToWall;
- (void)tryToFinishPostingToWall;
@end

@implementation SocializeFacebookWallPoster
@synthesize sentToWall = sentToWall_;

@synthesize options = options_;
@synthesize facebookInterface = facebookInterface_;

- (void)dealloc {
    self.options = nil;
    self.facebookInterface = nil;
    
    [super dealloc];
}

+ (void)postToFacebookWallWithOptions:(SocializeFacebookWallPostOptions*)options
                                  display:(id)display
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure {
    SocializeFacebookWallPoster *poster = [[[self alloc] initWithOptions:options display:display] autorelease];
    poster.successBlock = success;
    poster.failureBlock = failure;
    
    [SocializeAction executeAction:poster];
}

+ (void)postToFacebookWallWithOptions:(SocializeFacebookWallPostOptions*)options
                         displayProxy:(SocializeUIDisplayProxy*)proxy
                              success:(void(^)())success
                              failure:(void(^)(NSError *error))failure {
    SocializeFacebookWallPoster *poster = [[[self alloc] initWithOptions:options displayProxy:proxy] autorelease];
    poster.successBlock = success;
    poster.failureBlock = failure;

    [SocializeAction executeAction:poster];
}


- (SocializeFacebookInterface*)facebookInterface {
    if (facebookInterface_ == nil) {
        facebookInterface_ = [[SocializeFacebookInterface alloc] init];
    }
    
    return facebookInterface_;
}

- (void)authenticateViaFacebook {
    [SocializeFacebookAuthenticator authenticateViaFacebookWithOptions:self.options.facebookAuthOptions
                                                          displayProxy:self.displayProxy
                                                               success:^{
                                                                   [self tryToFinishPostingToWall];
                                                               } failure:^(NSError* error) {
                                                                   [self failWithError:error];
                                                               }];
}

- (void)sendPostToWall {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.options.message, @"message",
                            self.options.caption, @"caption",
                            self.options.link, @"link",
                            self.options.name, @"name",
                            nil];
    
    [self.facebookInterface requestWithGraphPath:@"me/feed" params:params httpMethod:@"POST" completion:^(id result, NSError *error) {
        if (error != nil) {
            [self failWithError:error];
        } else {
            self.sentToWall = YES;
            [self tryToFinishPostingToWall];
        }
    }];
}

- (void)tryToFinishPostingToWall {
    if (![self.socialize isAuthenticatedWithFacebook]) {
        [self authenticateViaFacebook];
        return;
    }
    
    if (!self.sentToWall) {
        [self sendPostToWall];
        return;
    }
    
    [self succeed];
}

- (void)executeAction {
    [self tryToFinishPostingToWall];
}

@end
