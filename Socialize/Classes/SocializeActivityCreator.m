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
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"

@interface SocializeActivityCreator ()
@property (nonatomic, assign) BOOL finishedServerCreate;
@property (nonatomic, assign) BOOL postedToFacebookWall;
@end

@implementation SocializeActivityCreator
@synthesize options = options_;
@synthesize activity = activity_;

@synthesize finishedServerCreate = finishedServerCreate_;
@synthesize postedToFacebookWall = postedToFacebookWall_;

- (void)dealloc {
    self.options = nil;
    self.activity = nil;
    
    [super dealloc];
}

- (id)initWithActivity:(id<SocializeActivity>)activity
               options:(SocializeOptions*)options
         displayProxy:(SocializeUIDisplayProxy*)displayProxy
              display:(id<SocializeUIDisplay>)display {
    
    if (self = [super initWithOptions:options displayProxy:displayProxy display:display]) {
        self.activity = activity;
    }
    return self;
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

- (BOOL)shouldPostToThirdParty:(Class<SocializeThirdParty>)thirdParty {
    for (NSString *name in self.options.thirdParties) {
        if ([[name lowercaseString] isEqualToString:[[thirdParty thirdPartyName] lowercaseString]]) {
            return YES;
        }
    }
    
    return [thirdParty isLinkedToSocialize];
}

- (BOOL)shouldPostToFacebook {
    return [self shouldPostToThirdParty:[SocializeThirdPartyFacebook class]];
}

- (BOOL)shouldPostToTwitter {
    return [self shouldPostToThirdParty:[SocializeThirdPartyTwitter class]];
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

- (BOOL)verifyThirdPartiesFromOptions {
    for (NSString *thirdPartyName in self.options.thirdParties) {
        Class<SocializeThirdParty> thirdParty = [SocializeThirdParty thirdPartyWithName:thirdPartyName];
        if (thirdParty == nil) {
            [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorThirdPartyNotAvailable]];
            return NO;
        } else if (![thirdParty isLinkedToSocialize]) {
            [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorThirdPartyNotLinked]];
            return NO;
        }
    }
    return YES;
}

- (void)executeAction {
    if (![self verifyThirdPartiesFromOptions]) {
        return;
    }
    
    [self tryToFinishCreatingActivity];
}

@end
