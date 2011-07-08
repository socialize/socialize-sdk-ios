//
//  SocializeShareService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareService.h"
#import "JSONKit.h"

@interface SocializeShareService()
//-(NSArray*)parseShares:(id)shareJsonData;
//-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest;
@end


#define SHARE_METHOD @"share/"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"

@implementation SocializeShareService



-(void) dealloc
{
    [super dealloc];
}
/*
- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
//    [_delegate viewService:self didFailWithError:error];
    [_delegate shareService:self didFailWithError:error];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    id responseObject = [responseString objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    if ([request.httpMethod  isEqualToString:@"POST"]){
        NSArray* views = [self parseShares:responseObject];
        // we are only supporting posting of singular create view request
        if ([views count])
            [_delegate shareService:self didReceiveShare:[views objectAtIndex:0]];
        else
            [_delegate shareService:self didFailWithError:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }
}

-(NSArray*)parseShares:(id)likesJsonData
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

-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(ShareMedium)medium  text:(NSString*)text{
    DLog(@"entity %@", entity);
    [self createShareForEntityKey:[entity key] medium:medium text:text];
}

-(void)createShareForEntityKey:(NSString*)key medium:(ShareMedium)medium  text:(NSString*)text{
    
    if (key && [key length]){   
        NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity", text, @"text", [NSNumber numberWithInt:medium], @"medium" , nil];
        NSArray *params = [NSArray arrayWithObjects:entityParam, 
                           nil];
        [_provider requestWithMethodName:SHARE_METHOD andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:self];
    }
}


@end
