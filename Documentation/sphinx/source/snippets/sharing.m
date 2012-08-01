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

// begin-manual-show-share-dialog-snippet

- (void)manuallyShowShareDialog {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZShareDialogViewController *share = [[SZShareDialogViewController alloc] initWithEntity:entity];
    
//    share.title = @"A Custom Title";
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    headerView.backgroundColor = [UIColor greenColor];    
//    share.headerView = headerView;
    
    share.completionBlock = ^(NSArray *shares) {
        
        // Dismiss however you want here
        [self dismissModalViewControllerAnimated:NO];
    };
    
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
    
    options.willAttemptPostToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        [postData.params setObject:@"Hey check out this site i found" forKey:@"message"];
        [postData.params setObject:@"http://www.facebook.com" forKey:@"link"];
        [postData.params setObject:@"A caption" forKey:@"caption"];
        [postData.params setObject:@"Facebook" forKey:@"name"];
        [postData.params setObject:@"A Site" forKey:@"description"];
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

    [SZShareUtils shareViaSMSWithViewController:self entity:entity success:^(id<SZShare> share) {
        
        NSLog(@"Created share: %@", share);
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error creating share: %@", [error localizedDescription]);
    }];
}

// end-show-sms-snippet

// begin-show-email-snippet

- (void)showEmail {
    id<SZEntity> entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
    
    [SZShareUtils shareViaEmailWithViewController:self entity:entity success:^(id<SZShare> share) {
        
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
