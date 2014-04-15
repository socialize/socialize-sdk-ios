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

static BOOL showInShare = NO;
static UIViewController *controller;
static id<SZEntity> shareEntity;
static void (^successBlock)(id<SZShare>);
static void (^failureBlock)(NSError *);

+ (void)setShowInShare:(BOOL)show {
    showInShare = show;
}

+ (NSString*)defaultMessageForShare:(id<SZShare>)share {
    NSDictionary *info = [[[share propagationInfoResponse] allValues] lastObject];
    NSString *entityURL = [info objectForKey:@"entity_url"];
    NSString *applicationURL = [info objectForKey:@"application_url"];
    
    id<SocializeEntity> e = share.entity;
    
    NSMutableString *msg = [NSMutableString stringWithString:@"I thought you would find this interesting: "];
    
    if ([e.name length] > 0) {
        [msg appendFormat:@"%@ ", e.name];
    }
    
    NSString *applicationName = [share.application name];
    
    [msg appendFormat:@"%@\n\nSent from %@ (%@)", entityURL, applicationName, applicationURL];
    
    return msg;
}

//operates purely on URL scheme and on whether it's been set to show in share
+ (BOOL)isAvailable {
    BOOL canOpenWhatsApp = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]] &&
                           showInShare;
    
    return canOpenWhatsApp;
}

//since WhatsApp doesn't have a callback mechanism, simply record the share and open WhatsApp
+ (void)shareViaWhatsAppWithViewController:(UIViewController *)viewController
                                    options:(SZShareOptions *)options
                                     entity:(id<SZEntity>)entity
                                    success:(void(^)(id<SZShare> share))success
                                    failure:(void(^)(NSError *error))failure {
    if (![self isAvailable]) {
        BLOCK_CALL_1(failure, [NSError defaultSocializeErrorForCode:SocializeWhatsAppNotAvailable]);
        return;
    }
    
    controller = viewController;
    shareEntity = entity;
    successBlock = success;
    failureBlock = failure;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp Share"
                                                    message:@"To share in WhatsApp, select the message recipient for the share. After you have finished, you will need to leave WhatsApp to navigate back here."
                                                   delegate:[SZWhatsAppUtils class]
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    [alert show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //go ahead with share
    if (buttonIndex == 1 && shareEntity != nil && successBlock != nil && failureBlock != nil) {
        [controller showSocializeLoadingViewInSubview:nil];
        SZShare *share = [SZShare shareWithEntity:shareEntity text:nil medium:SocializeShareMediumOther];
        [share setPropagationInfoRequest:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"facebook"] forKey:@"third_parties"]];
        
        [[Socialize sharedSocialize] createShare:share
                                         success:^(id<SZShare> serverShare) {
                                             BLOCK_CALL_1(successBlock, serverShare);
                                             [controller hideSocializeLoadingView];
                                             NSString *messageBody = [self defaultMessageForShare:serverShare];
                                             NSString *encodedMessageBody =
                                             (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                                   (CFStringRef)messageBody,
                                                                                                                   NULL,
                                                                                                                   CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
                                                                                                                   kCFStringEncodingUTF8);
                                             NSString *whatsAppMessageString = [NSString stringWithFormat:@"whatsapp://send?text=%@", encodedMessageBody];
                                             NSURL *whatsappURL = [NSURL URLWithString:whatsAppMessageString];
                                             [[UIApplication sharedApplication] openURL: whatsappURL];
                                         }
                                         failure:^(NSError *error) {
                                             [controller hideSocializeLoadingView];
                                             BLOCK_CALL_1(failureBlock, error);
                                         }];
    }
    //user cancel
    else if(buttonIndex == 0) {
        if([controller isKindOfClass:[SZShareDialogViewController class]]) {
            SZShareDialogViewController *shareController = (SZShareDialogViewController *)controller;
            [shareController deselectSelectedRow];
        }
    }
    else if(failureBlock != nil) {
        BLOCK_CALL_1(failureBlock, [NSError defaultSocializeErrorForCode:SocializeWhatsAppShareCancelledByUser]);
    }
}
    @end
