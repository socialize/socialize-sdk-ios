//
//  views.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "views.h"
#import <Socialize/Socialize.h>

@implementation views

// begin-record-snippet

- (void)recordView {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];

    [SZViewUtils viewEntity:entity success:^(id<SocializeView> view) {
        NSLog(@"View created: %d", [view objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Failed recording view: %@", [error localizedDescription]);
    }];
}

// end-record-snippet

// begin-get-for-user-snippet

- (void)getViewForUser {
    [SZViewUtils getViewsByUser:nil start:nil end:nil success:^(NSArray *views) {
        NSLog(@"Got views %@", views);
    } failure:^(NSError *error) {
        NSLog(@"Failed getting view: %@", [error localizedDescription]);
    }];
}

// end-get-for-user-snippet

// begin-get-for-user-and-entity-snippet

- (void)getViewsForUserOnEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"some_key" name:@"Something"];
    [SZViewUtils getViewsByUser:nil entity:entity start:nil end:nil success:^(NSArray *views) {
        NSLog(@"Got views %@", views);
    } failure:^(NSError *error) {
        NSLog(@"Failed getting views: %@", [error localizedDescription]);
    }];
}

// end-get-for-user-and-entity-snippet

@end
