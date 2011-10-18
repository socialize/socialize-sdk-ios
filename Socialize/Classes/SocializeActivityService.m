//
//  SocializeActivityService.m
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityService.h"


@implementation SocializeActivityService

-(void) getActivityOfCurrentUser;
{
    [self getActivityOfCurrentUserWithFirst:nil last:nil];
}

-(void) getActivityOfCurrentUserWithFirst:(NSNumber*)first last:(NSNumber*)last
{
    NSMutableDictionary* params = nil;
    
    if (first && last)
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: first, @"first", last, @"last", nil];

    
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"activity/"
                          expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                      params:params]
     ];
}

@end
