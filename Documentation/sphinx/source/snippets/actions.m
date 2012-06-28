//
//  actions.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "actions.h"
#import <Socialize/Socialize.h>

@implementation actions

// begin-application-snippet

- (void)getActionsByApplication {
    [SZActionUtils getActionsByApplicationWithStart:nil end:nil success:^(NSArray *actions) {
        for (id<SZActivity> action in actions) {
            NSLog(@"Found action %d by user %@ %@", [action objectID], [action.user firstName], [action.user lastName]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}

// end-application-snippet

// begin-entity-snippet

- (void)getActionsForAllUsersOnASingleEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"interesting_key"];
    
    [SZActionUtils getActionsByUser:nil entity:entity start:nil end:nil success:^(NSArray *actions) {
        for (id<SZActivity> action in actions) {
            NSLog(@"Found action %d by user %@ %@", [action objectID], [action.user firstName], [action.user lastName]);
        }

    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}

// end-entity-snippet

// begin-user-snippet

- (void)getActionsByUserOnAllEntities {
    [SZActionUtils getActionsByUser:nil start:nil end:nil success:^(NSArray *actions) {
        for (id<SZActivity> action in actions) {
            NSLog(@"Found action %d by user %@ %@", [action objectID], [action.user firstName], [action.user lastName]);
        }

    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}

// end-user-snippet

// begin-user-entity-snippet

- (void)getActionsByUserOnSingleEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"interesting_key"];
    
    [SZActionUtils getActionsByUser:nil entity:entity start:nil end:nil success:^(NSArray *actions) {
        for (id<SZActivity> action in actions) {
            NSLog(@"Found action %d by user %@ %@", [action objectID], [action.user firstName], [action.user lastName]);
        }

    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}

// end-user-entity-snippet


@end