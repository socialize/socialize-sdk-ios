//
//  SocializeViewService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeViewService.h"
#import "JSONKit.h"

@interface SocializeViewService()
//-(NSArray*)parseViews:(id)likesJsonData;
//-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest;
@end

#define VIEW_METHOD @"view/"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"

@implementation SocializeViewService


-(void) dealloc
{
    [super dealloc];
}
/*
- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    [_delegate viewService:self didFailWithError:error];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    id responseObject = [responseString objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    if ([request.httpMethod  isEqualToString:@"POST"]){
        NSArray* views = [self parseViews:responseObject];
        // we are only supporting posting of singular create view request
        if ([views count])
            [_delegate viewService:self didReceiveView:[views objectAtIndex:0]];
        else
            [_delegate viewService:self didFailWithError:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }
}

-(NSArray*)parseViews:(id)likesJsonData
{
    NSMutableArray* likes = nil;
    if ([likesJsonData isKindOfClass:[NSDictionary class]]){
        
        likes = [NSMutableArray array];
        id<SocializeView> like = [_objectCreator createObjectFromDictionary:likesJsonData forProtocol:@protocol(SocializeView)];
        [likes addObject:like];
        
    }
    else if ([likesJsonData isKindOfClass:[NSArray class]]){
        
        likes = [NSMutableArray arrayWithCapacity:[likesJsonData count]];
        [likesJsonData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             id<SocializeView> like = [_objectCreator createObjectFromDictionary:obj forProtocol:@protocol(SocializeView)];
             [likes addObject:like];
         }
         ];
    }
    
    return likes;
}
 */

-(void)createViewForEntity:(id<SocializeEntity>)entity{
    DLog(@"entity %@", entity);
    [self createViewForEntityKey:[entity key]];
}

-(void)createViewForEntityKey:(NSString*)key{
    
    if (key && [key length]){   
        NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity", nil];
        NSArray *params = [NSArray arrayWithObjects:entityParam, 
                           nil];
        [_provider requestWithMethodName:VIEW_METHOD andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:self];
    }
}

@end
