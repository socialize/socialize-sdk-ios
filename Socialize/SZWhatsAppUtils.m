//
//  SZWhatsAppUtils.m
//  Socialize
//
//  Created by David Jedeikin on 4/7/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SZWhatsAppUtils.h"
#import "NSError+Socialize.h"
#import "SDKHelpers.h"
#import "Socialize.h"

@implementation SZWhatsAppUtils

//+ (NSString*)defaultMessageForShare:(id<SZShare>)share {
//    NSDictionary *info = [[[share propagationInfoResponse] allValues] lastObject];
//    NSString *entityURL = [info objectForKey:@"entity_url"];
//    NSString *applicationURL = [info objectForKey:@"application_url"];
//    
//    id<SocializeEntity> e = share.entity;
//    
//    NSMutableString *msg = [NSMutableString stringWithString:@"I thought you would find this interesting: "];
//    
//    if ([e.name length] > 0) {
//        [msg appendFormat:@"%@ ", e.name];
//    }
//    
//    NSString *applicationName = [share.application name];
//    
//    [msg appendFormat:@"%@\n\nSent from %@ (%@)", entityURL, applicationName, applicationURL];
//    
//    return msg;
//}

//operates purely on URL scheme
+ (BOOL)isAvailable {
    BOOL canOpenWhatsApp = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]];
    return canOpenWhatsApp;
}

//since WhatsApp doesn't have a callback mechanism, simply record the share and open WhatsApp
+ (void)shareViaWhatsAppWithViewController:(UIViewController*)viewController
                                    options:(SZShareOptions*)options
                                     entity:(id<SZEntity>)entity
                                    success:(void(^)(id<SZShare> share))success
                                    failure:(void(^)(NSError *error))failure {
    if (![self isAvailable]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeWhatsAppNotAvailable]);
        return;
    }
    
    [viewController showSocializeLoadingViewInSubview:nil];
    
    SZShare *share = [SZShare shareWithEntity:entity text:nil medium:SocializeShareMediumOther];
    [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"facebook"] forKey:@"third_parties"]];

    [[Socialize sharedSocialize] createShare:share
                                     success:^(id<SZShare> serverShare) {
                                         [viewController hideSocializeLoadingView];
                                         NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=Hello%2C%20World!"];
                                         if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                                             [[UIApplication sharedApplication] openURL: whatsappURL];
                                         }
                                     }
                                     failure:^(NSError *error) {
                                         [viewController hideSocializeLoadingView];
                                         BLOCK_CALL_1(failure, error);
    }];
}
@end
