//
//  sharing.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "sharing.h"
#import <Socialize/Socialize.h>

@implementation sharing

// begin-show-share-dialog-snippet

- (void)showShareDialog {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
    [SZShareUtils showShareDialogWithViewController:self entity:entity completion:^(NSArray *shares) {
        // `shares` is a list of all shares created during the lifetime of the share dialog
        NSLog(@"Created %d shares: %@", [shares count], shares);
    } cancellation:^{
        NSLog(@"Share creation cancelled");
    }];
}

// end-show-share-dialog-snippet

// begin-show-share-dialog-with-options-snippet

- (void)showShareDialogWithOptions {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
    
    SZShareOptions *options = [SZShareUtils userShareOptions];
    
    options.dontShareLocation = YES;
    
    options.willShowSMSComposerBlock = ^(SZSMSShareData *smsData) {
        NSLog(@"Sharing SMS");
    };
    
    options.willShowEmailComposerBlock = ^(SZEmailShareData *emailData) {
        NSLog(@"Sharing Email");
    };
    
    options.willRedirectToPinterestBlock = ^(SZPinterestShareData *pinData)
    {
        NSLog(@"Sharing pin");
    };
    
    options.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        if (network == SZSocialNetworkTwitter) {
            NSString *entityURL = [[postData.propagationInfo objectForKey:@"twitter"] objectForKey:@"entity_url"];
            NSString *displayName = [postData.entity displayName];
            SZShareOptions *shareOptions = (SZShareOptions*)postData.options;
            NSString *text = shareOptions.text;
            
            NSString *customStatus = [NSString stringWithFormat:@"%@ / Custom status for %@ with url %@", text, displayName, entityURL];
            
            [postData.params setObject:customStatus forKey:@"status"];
            
        } else if (network == SZSocialNetworkFacebook) {
            NSString *entityURL = [[postData.propagationInfo objectForKey:@"facebook"] objectForKey:@"entity_url"];
            NSString *displayName = [postData.entity displayName];
            NSString *customMessage = [NSString stringWithFormat:@"Custom status for %@ ", displayName];
            
            [postData.params setObject:customMessage forKey:@"message"];
            [postData.params setObject:entityURL forKey:@"link"];
            [postData.params setObject:@"A caption" forKey:@"caption"];
            [postData.params setObject:@"Custom Name" forKey:@"name"];
            [postData.params setObject:@"A Site" forKey:@"description"];
        }
        
        NSLog(@"Posting to %d", network);
    };
    
    options.didSucceedPostingToSocialNetworkBlock = ^(SZSocialNetwork network, id result) {
        NSLog(@"Posted %@ to %d", result, network);
    };
    
    options.didFailPostingToSocialNetworkBlock = ^(SZSocialNetwork network, NSError *error) {
        NSLog(@"Failed posting to %d", network);
    };

    [SZShareUtils showShareDialogWithViewController:self options:options entity:entity completion:^(NSArray *shares) {
        // `shares` is a list of all shares created during the lifetime of the share dialog
        NSLog(@"Created %d shares: %@", [shares count], shares);
    } cancellation:^{
        NSLog(@"Share creation cancelled");
    }];
}

// end-show-share-dialog-with-options-snippet

// begin-manual-show-share-dialog-snippet

- (void)manuallyShowShareDialog {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZShareDialogViewController *share = [[SZShareDialogViewController alloc] initWithEntity:entity];
    
//    share.title = @"A Custom Title";
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    headerView.backgroundColor = [UIColor greenColor];    
//    share.headerView = headerView;
//    
//    SZShareOptions *options = [SZShareUtils userShareOptions];
//    options.text = @"Some default share text";
//    share.shareOptions = options;
//    share.dontShowComposer = YES;
    
    share.completionBlock = ^(NSArray *shares) {
        
        // Dismiss however you want here
        [self dismissModalViewControllerAnimated:NO];
    };
    
    // You can hide individual share types
//    share.hideEmail = YES;
//    share.hideSMS = YES;
//    share.hideFacebook = YES;
//    share.hideTwitter = YES;
//    share.hidePinterest = YES;
    
    // Present however you want here
    [self presentModalViewController:share animated:NO];
}

// end-manual-show-share-dialog-snippet


// begin-create-share-snippet

- (void)createShare {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
    SZShareOptions *options = [SZShareUtils userShareOptions];
    
    // Optionally disable location sharing
//    options.dontShareLocation = YES;
    
    // Optionally add an image (Twitter only)
//    options.image = [UIImage imageNamed:@"Smiley.png"];
    
    [SZShareUtils shareViaSocialNetworksWithEntity:entity networks:SZAvailableSocialNetworks() options:options success:^(id<SZShare> share) {
        
        NSLog(@"Created share: %@", share);
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error creating share: %@", [error localizedDescription]);
    }];
}

// end-create-share-snippet

// begin-customize-facebook-share-snippet

- (void)customizeFacebook {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
    SZShareOptions *options = [SZShareUtils userShareOptions];
    
    // http://developers.facebook.com/docs/reference/api/link/
    
    options.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        if (network == SZSocialNetworkFacebook) {
            [postData.params setObject:@"Hey check out this site i found" forKey:@"message"];
            [postData.params setObject:@"http://www.facebook.com" forKey:@"link"];
            [postData.params setObject:@"A caption" forKey:@"caption"];
            [postData.params setObject:@"Facebook" forKey:@"name"];
            [postData.params setObject:@"A Site" forKey:@"description"];
        }
    };
    
    [SZShareUtils shareViaSocialNetworksWithEntity:entity networks:SZAvailableSocialNetworks() options:options success:^(id<SZShare> share) {
        
        NSLog(@"Created share: %@", share);
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error creating share: %@", [error localizedDescription]);
    }];
}

// end-customize-facebook-share-snippet

// begin-show-sms-snippet

- (void)showSMS {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];

    SZShareOptions *options = [[SZShareOptions alloc] init];
    options.willShowSMSComposerBlock = ^(SZSMSShareData *smsData) {
        NSString *appURL = [smsData.propagationInfo objectForKey:@"application_url"];
        NSString *entityURL = [smsData.propagationInfo objectForKey:@"entity_url"];
        id<SZEntity> entity = smsData.share.entity;
        NSString *appName = smsData.share.application.name;
        
        smsData.body = [NSString stringWithFormat:@"Hark! (%@/%@, shared from the excellent %@ (%@))", entity.name, entityURL, appName, appURL];
    };
    

    [SZShareUtils shareViaSMSWithViewController:self options:options entity:entity success:^(id<SZShare> share) {
        
        NSLog(@"Created share: %@", share);
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error creating share: %@", [error localizedDescription]);
    }];
}

// end-show-sms-snippet

// begin-show-email-snippet

- (void)showEmail {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
    
    SZShareOptions *options = [[SZShareOptions alloc] init];
    options.willShowEmailComposerBlock = ^(SZEmailShareData *emailData) {
        emailData.subject = @"What's up?";
        
        NSString *appURL = [emailData.propagationInfo objectForKey:@"application_url"];
        NSString *entityURL = [emailData.propagationInfo objectForKey:@"entity_url"];
        id<SZEntity> entity = emailData.share.entity;
        NSString *appName = emailData.share.application.name;
        
        emailData.messageBody = [NSString stringWithFormat:@"Hark! (%@/%@, shared from the excellent %@ (%@))", entity.name, entityURL, appName, appURL];
    };

    [SZShareUtils shareViaEmailWithViewController:self options:options entity:entity success:^(id<SZShare> share) {
        
        NSLog(@"Created share: %@", share);
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error creating share: %@", [error localizedDescription]);
    }];
}

// end-show-email-snippet

// begin-get-shares-snippet

- (void)getSharesForEntity {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
    
    [SZShareUtils getSharesWithEntity:entity first:nil last:nil success:^(NSArray *shares) {
        NSLog(@"SHARES!!! %@", shares);
        
    } failure:^(NSError *error) {
        NSLog(@"Aww.. %@", [error localizedDescription]);
    }];
}

- (void)getSharesById {
    
    NSArray *ids = [NSArray arrayWithObject:[NSNumber numberWithInteger:10]];
    [SZShareUtils getSharesWithIds:ids success:^(NSArray *shares) {
        NSLog(@"SHARES!!! %@", shares);
        
    } failure:^(NSError *error) {
        NSLog(@"Aww.. %@", [error localizedDescription]);
    }];
}

- (void)getSharesByUser {
    [SZShareUtils getSharesWithUser:nil first:nil last:nil success:^(NSArray *shares) {
        
        NSLog(@"SHARES!!! %@", shares);
        
    } failure:^(NSError *error) {
        NSLog(@"Aww.. %@", [error localizedDescription]);
    }];
}

- (void)getSharesByUserAndEntity {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];

    [SZShareUtils getSharesWithUser:nil entity:entity first:nil last:nil success:^(NSArray *shares) {
        
        NSLog(@"SHARES!!! %@", shares);
        
    } failure:^(NSError *error) {
        NSLog(@"Aww.. %@", [error localizedDescription]);
    }];
}

// end-get-shares-snippet

// begin-list-by-application-snippet

- (void)listSharesByApplication {
    
    [SZShareUtils getSharesByApplicationWithFirst:nil last:nil success:^(NSArray *shares) {
        NSLog(@"Fetched shares: %@", shares);
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

// end-list-by-application-snippet

@end
