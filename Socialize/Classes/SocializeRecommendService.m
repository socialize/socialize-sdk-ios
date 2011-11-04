//
//  SocializeRecommendService.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeRecommendService.h"

@implementation SocializeRecommendService

    
-(NSDictionary *) getLikeRecommendation:(SocializeLike *)like {
    NSMutableDictionary *recDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *entities = [[NSMutableArray alloc] init];
    
    [recDict setObject:[NSNumber numberWithInt:like.objectID] forKey:@"like_id"];
    [recDict setObject:entities forKey:@"entities"];
    for( int i = 0; i < 4; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:i] forKey:@"id"];
        [dict setObject:[NSString stringWithFormat:@"http://www.google.com/%d", i] forKey:@"key"];
        [dict setObject:[NSString stringWithFormat:@"title: %d", i] forKey:@"name"];
        [dict setObject:[NSString stringWithFormat:@"type: %d", i] forKey:@"type"];
        [entities addObject:dict];
        [dict release];
    }
    return [recDict autorelease];
}
@end
