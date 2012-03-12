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
#import "StringHelper.h"

@interface SocializeActivityCreator ()
@property (nonatomic, assign) BOOL finishedServerCreate;
@property (nonatomic, assign) BOOL postedToFacebookWall;
@end

@implementation SocializeActivityCreator
@synthesize options = options_;
@synthesize activity = activity_;
@synthesize thirdParties = thirdParties_;
@synthesize activitySuccessBlock = activitySuccessBlock_;

@synthesize finishedServerCreate = finishedServerCreate_;
@synthesize postedToFacebookWall = postedToFacebookWall_;

- (void)dealloc {
    self.options = nil;
    self.activity = nil;
    self.thirdParties = nil;
    self.activitySuccessBlock = nil;
    
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

- (BOOL)shouldPostToThirdParty:(Class<SocializeThirdParty>)thirdParty {
    return [self.thirdParties containsObject:[[thirdParty thirdPartyName] lowercaseString]];
}

- (BOOL)shouldPostToFacebook {
    BOOL dontPostToFacebook = [[[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY] boolValue];
    return [self shouldPostToThirdParty:[SocializeThirdPartyFacebook class]]
    && !dontPostToFacebook;
}

- (BOOL)shouldPostToTwitter {
    BOOL dontPostToTwitter = [[[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY] boolValue];
    return [self shouldPostToThirdParty:[SocializeThirdPartyTwitter class]]
    && !dontPostToTwitter;
}

- (NSArray*)thirdParties {
    if (thirdParties_ == nil) {
        NSMutableArray *newThirdParties = [[NSMutableArray alloc] init];
        
        if (self.options.thirdParties != nil) {
            // User-specified list of thirdparties
            for (NSString *name in self.options.thirdParties) {
                [newThirdParties addObject:[name lowercaseString]];
            }
        } else {
            // Default list of thirdparties
            for (Class<SocializeThirdParty> thirdParty in [SocializeThirdParty allThirdParties]) {
                if ([thirdParty isLinkedToSocialize]) {
                    [newThirdParties addObject:[[thirdParty thirdPartyName] lowercaseString]];
                }
            }
        }
        thirdParties_ = newThirdParties;
    }
    return thirdParties_;
}

- (void)prepareActivityForCreate {
    if ([self shouldPostToTwitter]) {
        // Currently only twitter is allowed in the third parties list
        [self.activity setThirdParties:[NSArray arrayWithObject:@"twitter"]];
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
                                                           // Look the other way
                                                           self.postedToFacebookWall = YES;
                                                           [self tryToFinishCreatingActivity];
                                                       }];
}

- (void)succeedServerCreateWithActivity:(id<SocializeActivity>)activity {
    self.activity = activity;
    self.finishedServerCreate = YES;
    [self tryToFinishCreatingActivity];
}

- (void)failServerCreateWithError:(NSError*)error {
    if ([error isSocializeErrorWithCode:SocializeErrorServerReturnedErrors]) {
        NSArray *objects = [[error userInfo] objectForKey:kSocializeErrorServerObjectsArrayKey];
        
        if ([objects count] > 0) {
            id<SocializeActivity> activity = [objects objectAtIndex:0];
            if ([activity conformsToProtocol:@protocol(SocializeActivity)]) {
                // The server still created the activity, so we can continue.
                [self succeedServerCreateWithActivity:activity];
                return;
            }
        }
    }
    [self failWithError:error];
}

- (void)callSuccessBlock {
    if (self.activitySuccessBlock != nil) {
        self.activitySuccessBlock(self.activity);
    }
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
