//
//  standalone_share.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "standalone_share.h"
#import <Socialize/Socialize.h>

// begin-snippet

@implementation StandaloneShareViewController

- (IBAction)shareButtonPressed:(id)sender {
    SocializeEntity *entity = [SocializeEntity entityWithKey:@"my_key" name:@"An Entity"];
    [Socialize showShareActionSheetWithViewController:self entity:entity success:^{
        NSLog(@"Share created successfully");
    } failure:^(NSError *error) {
        if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
            NSLog(@"Share creation failed with error %@", [error localizedDescription]);        
        }
    }];
}

@end

// end-snippet