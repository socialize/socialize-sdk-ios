//
//  RecommendationTestCase.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "RecommendationTestCase.h"
#import "SocializeRecommendService.h"
@implementation RecommendationTestCase

-(void)testRecommendation {
    SocializeRecommendService *recommendService = [[SocializeRecommendService alloc] init];
    

    SocializeLike* like = [[SocializeLike new] autorelease];
    like.objectID = 2342;
    [recommendService getLikeRecommendation:like completion:^(id recommendations, NSError *error) {
        NSLog(@"completed!");
    }];
}
@end
