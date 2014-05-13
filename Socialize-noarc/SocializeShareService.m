//
//  SocializeShareService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareService.h"
#import "SocializeShare.h"
#import "_Socialize.h"
#import <Loopy/Loopy.h>
#import <AFNetworking/AFNetworking.h>

@interface SocializeShareService()
@end


#define SHARE_METHOD @"share/"

@implementation SocializeShareService

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeShare);
}

- (void)createShare:(id<SocializeShare>)share {
    [self createShare:share success:nil failure:nil loopySuccess:nil loopyFailure:nil];
}

- (void)createShare:(id<SocializeShare>)share
            success:(void(^)(id<SZShare> share))success
            failure:(void(^)(NSError *error))failure {
    [self createShare:share success:success failure:failure loopySuccess:nil loopyFailure:nil];
}

- (void)createShare:(id<SocializeShare>)share
            success:(void(^)(id<SZShare> share))success
            failure:(void(^)(NSError *error))failure
       loopySuccess:(id)loopySuccess
       loopyFailure:(id)loopyFailure {
    //perform Socialize share
    NSDictionary *params = [_objectCreator createDictionaryRepresentationOfObject:share];
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                                                           resourcePath:SHARE_METHOD
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:[NSArray arrayWithObject:params]];
    request.successBlock = ^(NSArray *shares) {
        BLOCK_CALL_1(success, [shares objectAtIndex:0]);
        
        //now call out to Loopy with Socialize URL
        SocializeShare *shareObj = (SocializeShare *)[shares objectAtIndex:0];
        id<SocializeEntity> entityObj = shareObj.entity;
        NSString *key = [entityObj key];
        NSString *medium = (NSString *)[params objectForKey:@"medium"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *mediumNbr = [formatter numberFromString:medium];
        int mediumInt = [mediumNbr intValue];
        NSString *channelStr = [self getNetworksForLoopy:mediumInt];
        BOOL keyIsURL = [entityObj keyIsURL];
        
        if(keyIsURL) {
            NSString *keyURL = key;
            [self reportLoopySharelink:keyURL
                               channel:channelStr
                               success:loopySuccess
                               failure:loopyFailure];
        }
        else {
            NSString *shareText = (NSString *)[params objectForKey:@"text"];
            [self reportLoopyShare:shareText
                           channel:channelStr
                           success:loopySuccess
                           failure:loopyFailure];
        }
    };
    request.failureBlock = failure;
    [self executeRequest:request];
}

//Loopy analytics reporting
- (void)reportLoopyShare:(NSString *)shareText
                 channel:(NSString *)channel
                 success:(id)successObj
                 failure:(id)failureObj {
    STAPIClient *loopyAPIClient = (STAPIClient *)[Socialize sharedLoopyAPIClient];
    STShare * shareObj = [loopyAPIClient reportShareWithShortlink:shareText channel:channel];
    [loopyAPIClient reportShare:shareObj
                        success:successObj
                        failure:failureObj];
}

//Loopy analytics reporting
- (void)reportLoopySharelink:(NSString *)urlStr
                     channel:(NSString *)channel
                     success:(id)successObj
                  failure:(id)failureObj {
    STAPIClient *loopyAPIClient = (STAPIClient *)[Socialize sharedLoopyAPIClient];
    STSharelink *sharelinkObj = [loopyAPIClient sharelinkWithURL:urlStr channel:channel title:nil meta:nil tags:nil];
    [loopyAPIClient sharelink:sharelinkObj success:successObj failure:failureObj];
}

//for now, simply text-ify networks being shared
- (NSString *)getNetworksForLoopy:(int)networks {
    NSString *channel = @"";
    switch (networks) {
        case SocializeShareMediumTwitter:
            channel = @"twitter";
            break;
            
        case SocializeShareMediumFacebook:
            channel = @"facebook";
            break;
            
        case SocializeShareMediumEmail:
            channel = @"email";
            break;
            
        case SocializeShareMediumSMS:
            channel = @"sms";
            break;
            
        case SocializeShareMediumPinterest:
            channel = @"pinterest";
            break;
            
        case SocializeShareMediumOther:
            channel = @"facebook,twitter";
            break;
            
        default:
            break;
    }
    
    return channel;
}

-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(SocializeShareMedium)medium  text:(NSString*)text {
    [self createShareForEntityKey:[entity key] medium:medium text:text];
}

-(void)createShareForEntityKey:(NSString*)key medium:(SocializeShareMedium)medium  text:(NSString*)text {
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

- (void)getSharesForEntityKey:(NSString*)key
                        first:(NSNumber*)first
                         last:(NSNumber*)last
                      success:(void(^)(NSArray *shares))success
                      failure:(void(^)(NSError *error))failure {
    
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    if (key)
        [params setObject:key forKey:@"entity_key"];
    if (first && last){
        [params setObject:first forKey:@"first"];
        [params setObject:last forKey:@"last"];
    }
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"GET"
                                                           resourcePath:SHARE_METHOD
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

- (void)getSharesWithFirst:(NSNumber*)first
                      last:(NSNumber*)last
                   success:(void(^)(NSArray *shares))success
                   failure:(void(^)(NSError *error))failure {
    [self callListingGetEndpointWithPath:SHARE_METHOD params:nil first:first last:last success:success failure:failure];
}


@end
