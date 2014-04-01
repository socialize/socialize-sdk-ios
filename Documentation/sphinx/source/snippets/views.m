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
    SZEntity *entity = [SZEntity entityWithKey:@"some_key_or_url" name:@"Something"];

    [SZViewUtils viewEntity:entity success:^(id<SocializeView> view) {
        NSLog(@"View created: %d", [view objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Failed recording view: %@", [error localizedDescription]);
    }];
}

// end-record-snippet

@end
