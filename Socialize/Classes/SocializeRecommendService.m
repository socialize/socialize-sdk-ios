//
//  SocializeRecommendService.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeRecommendService.h"
#import "JSONKit.h"

@implementation SocializeRecommendService

@synthesize handlers = _handlers;

-(id) init {
    if( self = [super init] ) {
        self.handlers = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void) getLikeRecommendation:(SocializeLike *)like  completion:(void (^)(NSDictionary *recommendations, NSError *error))completion {
    
    NSString *urlString = [NSString stringWithFormat:@"http://interests.getsocialize.com/recommendation/entity/?like_id=%d", like.objectID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *jsonResponse = (NSDictionary *)[data objectFromJSONData];
    NSLog(@" %@ ", jsonResponse);
    
    if (completion != nil) {
        [self.handlers setObject:[[completion copy] autorelease] forKey:request];
        completion(jsonResponse, error);
    }
    
}
-(void)dealloc {
    self.handlers = nil;
}
@end
