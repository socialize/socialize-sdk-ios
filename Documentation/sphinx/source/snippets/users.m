//
//  users.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "users.h"
#import <Socialize/Socialize.h>

@implementation users

// begin-show-profile-snippet

- (void)showUserProfile {
    
    // Pass nil to show the current user
    [SZUserUtils showUserProfileInViewController:self user:nil completion:^(id<SZFullUser> user) {
        NSLog(@"Done showing profile");
    }];
}

// end-show-profile-snippet

// begin-show-settings-snippet

- (void)showUserSettings {
    [SZUserUtils showUserSettingsInViewController:self completion:^{
        NSLog(@"Done showing settings");
    }];
}

// end-show-settings-snippet

// begin-show-link-dialog-snippet

- (void)showLinkDialog {
    if (![SZUserUtils userIsLinked]) {
        [SZUserUtils showLinkDialogWithViewController:self completion:^(SZSocialNetwork selectedNetwork) {
            NSLog(@"Linked!");
        } cancellation:^{
            NSLog(@"Not linked!");
        }];
    }
}

// end-show-link-dialog-snippet

// begin-current-user-snippet

- (void)getCurrentUser {
    id<SZFullUser> currentUser = [SZUserUtils currentUser];
    NSLog(@"My name is %@ %@!", [currentUser firstName], [currentUser lastName]);
}

// end-current-user-snippet

// begin-other-user-snippet

- (void)getOtherUser {
    
    // I have stashed a list of ids somewhere
    NSArray *ids = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:3], nil];
    
    [SZUserUtils getUsersWithIds:ids success:^(NSArray *users) {
        NSLog(@"Got users: %@", users);
    } failure:^(NSError *error) {
        NSLog(@"Failed to get users: %@", [error localizedDescription]);
    }];
}

// end-other-user-snippet

// begin-save-settings-snippet

- (void)saveSettings {
    
    // Specify a new image and description for the current user
    SZUserSettings *settings = [SZUserUtils currentUserSettings];
    UIImage *newImage = [UIImage imageNamed:@"Smiley.png"];
    settings.profileImage = newImage;
    settings.bio = @"I do some stuff from time to time";
    
    // Update the server
    [SZUserUtils saveUserSettings:settings success:^(SZUserSettings *settings, id<SocializeFullUser> updatedUser) {
        NSLog(@"Saved user %d", [updatedUser objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Broke: %@", [error localizedDescription]);
    }];
}

// end-save-settings-snippet

@end
