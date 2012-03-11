//
//  SocializeActivityCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityCreator.h"
#import "SocializeActivityOptions.h"
#import "SocializeFacebookWallPoster.h"
#import "_Socialize.h"
#import "SocializeThirdParty.h"
#import "SocializeUIDisplayProxy.h"

@interface SocializeActivityCreator ()
@property (nonatomic, assign) BOOL finishedServerCreate;
@property (nonatomic, assign) BOOL postedToFacebookWall;
@end

@implementation SocializeActivityCreator
@synthesize thirdParties = thirdParties_;
@synthesize options = options_;
@synthesize activity = activity_;

@synthesize finishedServerCreate = finishedServerCreate_;
@synthesize postedToFacebookWall = postedToFacebookWall_;

- (void)dealloc {
    self.thirdParties = nil;
    self.options = nil;
    self.activity = nil;
    
    [super dealloc];
}

- (id)initWithActivity:(id<SocializeActivity>)activity
         displayObject:(id)displayObject
               display:(id)display
               options:(SocializeActivityOptions*)options
               success:(void(^)())success
               failure:(void(^)(NSError *error))failure {
    
    if (self = [super initWithDisplayObject:displayObject display:display success:success failure:failure]) {
        self.options = options;
    }
    
    return self;
}

- (NSSet*)thirdParties {
    if (thirdParties_ == nil) {
        thirdParties_ = [[NSMutableSet alloc] init];
        
        NSMutableSet *newThirdParties = [NSMutableSet set];
        if (self.options.thirdParties != nil) {
            // Custom third parties list
            for (NSString *thirdParty in self.options.thirdParties) {
                [newThirdParties addObject:[thirdParty lowercaseString]];
            }
        } else {
            // Use all linked third parties
            for (Class<SocializeThirdParty> thirdParty in [SocializeThirdParty allThirdParties]) {
                [newThirdParties addObject:[[thirdParty thirdPartyName] lowercaseString]];
            }
        }
        thirdParties_ = newThirdParties;
    }
    
    return thirdParties_;
}

- (void)verifyThirdParties {
    
}

- (void)createActivityOnSocializeServer {
    NSAssert(NO, @"Not implemented");
}

- (NSString*)defaultText {
    NSAssert(NO, @"Not implemented");
    return nil;
}

- (NSString*)activityText {
    if ([self.activity respondsToSelector:@selector(text)]) {
        return [(id)self.activity text];
    }
    
    return nil;
}

// Activity-specific text for facebook
- (NSString*)textForFacebook {
    NSAssert(NO, @"Not implemented");
    return nil;
}

// The full message parameter
- (NSString*)facebookWallMessage {
    NSMutableString *message = [[[self textForFacebook] mutableCopy] autorelease];
    
    if (![Socialize disableBranding]) {
        [message appendFormat:@"\n\n Shared from %@ using Socialize for iOS. \n http://www.getsocialize.com/", self.activity.application.name];
    }

    return message;
}

// Activity-specific text for twitter
- (NSString*)textForTwitter {
    NSAssert(NO, @"Not implemented");
    return nil;
}

- (BOOL)shouldPostToFacebook {
    return [self.thirdParties containsObject:@"facebook"];
}

- (BOOL)shouldPostToTwitter {
    return [self.thirdParties containsObject:@"twitter"];
}

- (void)prepareActivityForCreate {
    if ([self shouldPostToTwitter]) {
        [self.activity setTwitterText:[self textForTwitter]];
    }
}

- (SocializeFacebookWallPostOptions*)facebookWallPostOptions {
    SocializeFacebookWallPostOptions *options = [SocializeFacebookWallPostOptions options];
    options.link = [NSString stringWithSocializeURLForApplication];
    options.caption = [NSString stringWithSocializeAppDownloadPlug];
    options.name = [NSString stringWithTitleForSocializeEntity:self.activity.entity];
    options.message = [self facebookWallMessage];
    
    return options;
}

- (void)postToFacebookWall {
    [SocializeFacebookWallPoster postToFacebookWallWithOptions:[self facebookWallPostOptions]
                                                  displayProxy:self.displayProxy
                                                       success:^{
                                                           self.postedToFacebookWall = YES;
                                                           [self tryToFinishCreatingActivity];
                                                       } failure:^(NSError *error) {
                                                           [self failWithError:error];
                                                       }];
}

- (void)succeedServerCreateWithActivity:(id<SocializeActivity>)activity {
    self.activity = activity;
    self.finishedServerCreate = YES;
    [self tryToFinishCreatingActivity];
}

- (void)tryToFinishCreatingActivity {
    if (!self.finishedServerCreate) {
        [self prepareActivityForCreate];
        [self createActivityOnSocializeServer];
        return;
    }
    
    if (!self.postedToFacebookWall && [self shouldPostToFacebook]) {
        [self postToFacebookWall];
        return;
    }
    
    [self succeed];
}

- (void)executeAction {
    [self tryToFinishCreatingActivity];
}

@end
