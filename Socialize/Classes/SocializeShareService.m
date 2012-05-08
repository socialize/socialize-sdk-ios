//
//  SocializeShareService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareService.h"
#import "SocializeShare.h"

@interface SocializeShareService()
@end


#define SHARE_METHOD @"share/"

@implementation SocializeShareService

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeShare);
}

- (void)createShare:(id<SocializeShare>)share {
    [self createShare:share success:nil failure:nil];
}

- (void)createShare:(id<SocializeShare>)share success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = [_objectCreator createDictionaryRepresentationOfObject:share];
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                                                           resourcePath:SHARE_METHOD
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:[NSArray arrayWithObject:params]];
    request.successBlock = success;
    request.failureBlock = failure;

    [self executeRequest:request];
}

-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(SocializeShareMedium)medium  text:(NSString*)text{
    [self createShareForEntityKey:[entity key] medium:medium text:text];
}

-(void)createShareForEntityKey:(NSString*)key medium:(SocializeShareMedium)medium  text:(NSString*)text{
    
    if (key && [key length]){   
        NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity_key", text, @"text", [NSNumber numberWithInt:medium], @"medium" , nil];
        NSArray *params = [NSArray arrayWithObjects:entityParam, 
                           nil];
        [self executeRequest:
         [SocializeRequest requestWithHttpMethod:@"POST"
                                    resourcePath:SHARE_METHOD
                              expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                          params:params]
         ];
    }
}

-(void)getSharesWithIds:(NSArray*)shareIds success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    
    NSMutableDictionary*  params = [[[NSMutableDictionary alloc] init] autorelease]; 
    [params setObject:shareIds forKey:@"id"];
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"GET"
                                                           resourcePath:SHARE_METHOD
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];

    request.successBlock = success;
    request.failureBlock = failure;
    [self executeRequest:request];
}

-(void)getShareWithId:(NSNumber*)shareId success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure {
    [self getSharesWithIds:[NSArray arrayWithObject:shareId]
                   success:^(NSArray *shares) {
                       BLOCK_CALL_1(success, [shares objectAtIndex:0]);
                   } failure:failure];
}


@end
