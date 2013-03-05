//
//  likes.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "likes.h"
#import <Socialize/Socialize.h>

@implementation likes

// begin-create-like-snippet

- (void)like {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    
    SZLikeOptions *options = [SZLikeUtils userLikeOptions];
    options.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        [postData.params setObject:@"Custom message" forKey:@"message"];
    };

    [SZLikeUtils likeWithEntity:entity options:nil networks:SZAvailableSocialNetworks() success:^(id<SZLike> like) {
        NSLog(@"Created like: %d", [like objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Failed creating like: %@", [error localizedDescription]);
    }];
}

// end-create-like-snippet

// begin-delete-like-snippet

- (void)unlike {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    
    [SZLikeUtils unlike:entity success:^(id<SZLike> like) {
        NSLog(@"Deleted like: %d", [like objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Failed deleting like: %@", [error localizedDescription]);
    }];
}

// end-delete-like-snippet

// begin-get-by-user-snippet

- (void)getLikesByUser {
    [SZLikeUtils getLikesForUser:nil start:nil end:nil success:^(NSArray *likes) {
        NSLog(@"Got likes: %@", likes);
    } failure:^(NSError *error) {
        NSLog(@"Failed getting likes: %@", [error localizedDescription]);
    }];
}

// end-get-by-user-snippet

// begin-get-by-user-and-entity-snippet

- (void)getLikeForUserOnEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    [SZLikeUtils getLikeForUser:nil entity:entity success:^(id<SZLike> like) {
        if (like != nil) {
            NSLog(@"Liked with like descriptor: %@", like);
        } else {
            NSLog(@"Not liked");
        }
    } failure:^(NSError *error) {
        NSLog(@"Failed getting like: %@", [error localizedDescription]);
    }];
}

// end-get-by-user-and-entity-snippet

// begin-get-by-entity-snippet

- (void)getLikesByEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    
    [SZLikeUtils getLikesForEntity:entity start:nil end:nil success:^(NSArray *likes) {
        NSLog(@"Got likes: %@", likes);
    } failure:^(NSError *error) {
        NSLog(@"Failed getting likes: %@", [error localizedDescription]);
    }];
}

// end-get-by-entity-snippet

// begin-list-by-application-snippet

- (void)listLikesByApplication {
    
    [SZLikeUtils getLikesByApplicationWithFirst:nil last:nil success:^(NSArray *likes) {
        NSLog(@"Fetched likes: %@", likes);
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
    }];
}

// end-list-by-application-snippet


// begin-observe-likes-snippet

- (void)didCreate:(NSNotification*)notification {
    NSArray *objects = [[notification userInfo] objectForKey:kSZCreatedObjectsKey];

    id<SZLike> like = [objects lastObject];
    if ([like conformsToProtocol:@protocol(SZLike)]) {
        NSLog(@"Liked %@", like.entity);
    }
}

- (void)didDelete:(NSNotification*)notification {
    NSArray *objects = [[notification userInfo] objectForKey:kSZDeletedObjectsKey];

    id<SZLike> like = [objects lastObject];
    if ([like conformsToProtocol:@protocol(SZLike)]) {
        NSLog(@"Unliked %@", like.entity);
    }
}

- (void)respondToLikeChanges {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreate:) name:SZDidCreateObjectsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDelete:) name:SZDidDeleteObjectsNotification object:nil];
    
}

// end-observe-likes-snippet

@end
