//
//  SocializeUILikeCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUILikeCreator.h"
#import "SocializeAuthViewController.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeLikeCreator.h"
#import "SocializeThirdPartyLinker.h"

@interface SocializeUILikeCreator ()
@property (nonatomic, assign) BOOL finishedCreatingLike;
@property (nonatomic, assign) BOOL finishedLinkingToThirdParty;
@end

@implementation SocializeUILikeCreator
@synthesize finishedCreatingLike = finishedCreatingLike_;
@synthesize finishedLinkingToThirdParty = finishedLinkingToThirdParty_;
@synthesize likeSuccessBlock = likeSuccessBlock_;
@synthesize like = like_;

- (void)dealloc {
    self.options = nil;
    
    [super dealloc];
}

+ (void)createLike:(id<SocializeLike>)like
           options:(SocializeUILikeOptions*)options
      displayProxy:(SocializeUIDisplayProxy*)displayProxy
           success:(void(^)(id<SocializeLike>))success
           failure:(void(^)(NSError *error))failure {
    
    SocializeUILikeCreator *likeCreator = [[[self alloc] initWithOptions:options displayProxy:displayProxy] autorelease];
    likeCreator.like = like;
    likeCreator.likeSuccessBlock = success;
    likeCreator.failureBlock = failure;
    
    [SocializeAction executeAction:likeCreator];
}

- (id)initWithOptions:(SocializeUILikeOptions *)options displayProxy:(SocializeUIDisplayProxy *)displayProxy display:(id<SocializeUIDisplay>)display {
    if (self = [super initWithOptions:options displayProxy:displayProxy display:display]) {
        self.options = options;
    }
    
    return self;
}

- (void)callSuccessBlock {
    if (self.likeSuccessBlock != nil) {
        self.likeSuccessBlock(self.like);
    }
}

- (void)createLike {
    [SocializeLikeCreator createLike:self.like options:nil displayProxy:self.displayProxy success:^(id<SocializeLike> createdLike) {
        self.like = createdLike;
        self.finishedCreatingLike = YES;
        [self tryToFinishCreatingLike];
    } failure:^(NSError *error) {
        [self failWithError:error];
    }];
}

- (void)linkToThirdParty {
    [SocializeThirdPartyLinker linkToThirdPartyWithOptions:nil displayProxy:self.displayProxy success:^{
        self.finishedLinkingToThirdParty = YES;
    } failure:^(NSError *error) {
        [self failWithError:error];
    }];
}

- (void)tryToFinishCreatingLike {
    if (!self.finishedLinkingToThirdParty) {
        [self linkToThirdParty];
    }
    
    if (!self.finishedCreatingLike) {
        [self createLike];
        return;
    }
    
    [self succeed];
}

- (void)executeAction {
    [self tryToFinishCreatingLike];
}

@end
