//
//  SDKHelpers.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SDKHelpers.h"
#import "SocializeObjects.h"
#import "SZShareOptions.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"

SocializeShareMedium SocializeShareMediumForSZShareOptions(SZShareOptions *options) {
    // Currently Must exlusively share to a Social Network for this to be the medium.
    SocializeShareMedium medium;
    if (options.shareTo == SZSocialNetworkFacebook) {
        medium = SocializeShareMediumFacebook;
    } else if (options.shareTo == SZSocialNetworkTwitter) {
        medium = SocializeShareMediumTwitter;
    } else {
        medium = SocializeShareMediumOther;
    }
    return medium;
}

void CreateAndShareActivity(id<SZActivity> activity, SZShareOptions *options, ActivityCreatorBlock creator, void (^success)(id<SZActivity> activity), void (^failure)(NSError *error)) {
    if (options.shareTo & SZSocialNetworkFacebook && (![SZFacebookUtils isAvailable] || ![SZFacebookUtils isLinked])) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorFacebookUnavailable]);
        return;
    }
    
    if (options.shareTo & SZSocialNetworkTwitter && (![SZTwitterUtils isAvailable] || ![SZTwitterUtils isLinked])) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeErrorTwitterUnavailable]);
        return;
    }
    
    if (options.shareTo & SZSocialNetworkFacebook) {
        activity.propagationInfoRequest = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"facebook"] forKey:@"third_parties"];
    }
    
    if (options.shareTo & SZSocialNetworkTwitter) {
        activity.propagation = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"twitter"] forKey:@"third_parties"];
    }
    
    creator(activity, ^(id<SZActivity> activity) {
        if (options.shareTo & SZSocialNetworkFacebook) {
            
            // This shortened link returned from the server encapsulates all the Socialize magic
            NSString *shareURL = [[[activity propagationInfoResponse] objectForKey:@"facebook"] objectForKey:@"application_url"];
            
            NSString *name = activity.application.name;
            NSString *link = shareURL;
            NSString *caption = [NSString stringWithSocializeAppDownloadPlug];
            
            // Build the message string
            NSMutableString *message = [NSMutableString string];
            if ([activity.entity.name length] > 0) {
                [message appendFormat:@"%@: ", activity.entity.name];
            }
            
            [message appendFormat:@"%@\n\n", shareURL];
            
            NSString *text = nil;
            if ([activity respondsToSelector:@selector(text)]) {
                text = [(id)activity text];
            }
            if ([text length] > 0) {
                [message appendFormat:@"%@\n\n", text];
            }
            
            [message appendFormat:@"Shared from %@.", activity.application.name];
            
            NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      message, @"message",
                                      caption, @"caption",
                                      link, @"link",
                                      name, @"name",
                                      @"This is the description", @"description",
                                      nil];
            
            [SZFacebookUtils postWithGraphPath:@"me/links" postData:postData success:^(id result) {
                BLOCK_CALL_1(success, activity);
            } failure:^(NSError *error) {
                
                // Failed Wall post is still a success. Handle separately in options.
                BLOCK_CALL_1(success, activity);
            }];
        }
        
        BLOCK_CALL_1(success, activity);
    }, failure);

}