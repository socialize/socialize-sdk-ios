//
//  comments.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "comments.h"
#import <Socialize/Socialize.h>

@implementation comments

// begin-show-comments-list-snippet

- (void)showCommentsList {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    [SZCommentUtils showCommentsListWithViewController:self entity:entity completion:nil];
}

// end-show-comments-list-snippet

// begin-manual-show-comments-list-snippet

- (void)manuallyShowCommentsList {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZCommentsListViewController *comments = [[SZCommentsListViewController alloc] initWithEntity:entity];
    comments.completionBlock = ^{
        
        // Dismiss however you want here
        [self dismissModalViewControllerAnimated:NO];
    };
    
    // Present however you want here
    [self presentModalViewController:comments animated:NO];
}

// end-manual-show-comments-list-snippet

// begin-show-comment-composer-snippet

- (void)showCommentComposer {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    [SZCommentUtils showCommentComposerWithViewController:self entity:entity completion:^(id<SZComment> comment) {
        NSLog(@"Created comment: %@", [comment text]);
    } cancellation:^{
        NSLog(@"Cancelled comment create");
    }];
}

// end-show-comment-composer-snippet

// begin-manual-show-comment-composer-snippet

- (void)manuallyShowCommentComposer {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"name"];
    SZComposeCommentViewController *composer = [[SZComposeCommentViewController alloc] initWithEntity:entity];
    composer.completionBlock = ^(id<SZComment> comment) {
        NSLog(@"Created comment: %@", [comment text]);
        // Dismiss however you want here
        [self dismissModalViewControllerAnimated:NO];
    };
    
    // Present however you want here
    [self presentModalViewController:composer animated:NO];
}

// end-manual-show-comment-composer-snippet

// begin-add-comment-snippet

- (void)addComment {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    
    SZCommentOptions *options = [SZCommentUtils userCommentOptions];
    options.willAttemptPostToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        [postData.params setObject:@"Custom message" forKey:@"message"];
    };
    
    [SZCommentUtils addCommentWithEntity:entity text:@"A Comment!" options:options networks:SZAvailableSocialNetworks() success:^(id<SZComment> comment) {
        NSLog(@"Created comment: %@", [comment text]);
    } failure:^(NSError *error) {
        NSLog(@"Failed creating comment: %@", [error localizedDescription]);
    }];
}

// end-add-comment-snippet


// begin-add-comment-ui-snippet

- (void)addCommentPromptForNetworks {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    
    SZCommentOptions *options = [SZCommentUtils userCommentOptions];
    [SZCommentUtils addCommentWithViewController:self entity:entity text:@"A comment!" options:options success:^(id<SZComment> comment) {
        
        NSLog(@"Created comment: %@", [comment text]);
    } failure:^(NSError *error) {
        NSLog(@"Failed creating comment: %@", [error localizedDescription]);
    }];
}

// end-add-comment-ui-snippet

// begin-list-by-user-snippet

- (void)listCommentsByUser {
    [SZCommentUtils getCommentsByUser:nil first:nil last:nil success:^(NSArray *comments) {
        NSLog(@"Fetched comments: %@", comments);
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

// end-list-by-user-snippet

// begin-list-by-user-and-entity-snippet

- (void)listCommentsByUserAndEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];

    [SZCommentUtils getCommentsByUser:USER_ADDR_NULL entity:entity first:nil last:nil success:^(NSArray *comments) {
        NSLog(@"Fetched comments: %@", comments);
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

// end-list-by-user-and-entity-snippet

// begin-list-by-entity-snippet

- (void)listCommentsByEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    
    [SZCommentUtils getCommentsByEntity:entity success:^(NSArray *comments) {
        NSLog(@"Fetched comments: %@", comments);
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

// end-list-by-entity-snippet

// begin-list-by-ids-snippet

- (void)listCommentsByIds {
    
    // I've stashed these ids somewhere
    NSArray *ids = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:1], nil];
    
    [SZCommentUtils getCommentsWithIds:ids success:^(NSArray *comments) {
        NSLog(@"Fetched comments: %@", comments);
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

// end-list-by-ids-snippet

// begin-list-by-application-snippet

- (void)listCommentsByApplication {
    
    [SZCommentUtils getCommentsByApplicationWithFirst:nil last:nil success:^(NSArray *comments) {
        NSLog(@"Fetched comments: %@", comments);
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

// end-list-by-application-snippet

@end
