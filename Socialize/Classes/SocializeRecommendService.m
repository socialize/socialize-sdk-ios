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
typedef void (^RequestCompletionBlock)(NSDictionary *result, NSError *error);
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
    
    [self.handlers setObject:[[completion copy] autorelease] forKey:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * response, NSData *data, NSError *error) {
        NSDictionary *jsonResponse = (NSDictionary *)[data objectFromJSONData];
        NSLog(@"response from server: %@", jsonResponse);
        if (completion != nil) {
            RequestCompletionBlock completionBlock = [self.handlers objectForKey:request];
            completionBlock(jsonResponse, error);
        }
    }];

    
}
-(void)dealloc {
    self.handlers = nil;
}
@end
