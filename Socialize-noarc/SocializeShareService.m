//
//  SocializeShareService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareService.h"
#import "SocializeShare.h"
#import <Loopy/Loopy.h>
#import "_Socialize.h"

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
    request.successBlock = ^(NSArray *shares) {
        BLOCK_CALL_1(success, [shares objectAtIndex:0]);
        //report to Loopy
        NSString *shareText = (NSString *)[params objectForKey:@"text"];
        NSString *medium = (NSString *)[params objectForKey:@"medium"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *mediumNbr = [formatter numberFromString:medium];
        int mediumInt = [mediumNbr intValue];
        [self reportShareToLoopyWithText:shareText
                                 channel:[self getNetworksForLoopy:mediumInt]
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         }
                                 failure:nil];
    };
    
    request.failureBlock = failure;

    [self executeRequest:request];
}

//Loopy analytics reporting
- (void)reportShareToLoopyWithText:(NSString *)shareText
                           channel:(NSString *)channel
                           success:(id)success
                           failure:(id)failure {
    //cast callbacks until .h import failure issue fixed
    void(^successCallback)(AFHTTPRequestOperation *operation, id responseObject) = (void(^)(AFHTTPRequestOperation *, id))success;
    void(^failureCallback)(AFHTTPRequestOperation *operation, NSError *error) = (void(^)(AFHTTPRequestOperation *, NSError *))failure;
    
    STAPIClient *loopyAPIClient = (STAPIClient *)[Socialize sharedLoopyAPIClient];
    NSDictionary *shareDict = [loopyAPIClient reportShareDictionary:shareText channel:channel];
    [loopyAPIClient reportShare:shareDict
                        success:successCallback
                        failure:failureCallback];
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

- (void)getSharesForEntityKey:(NSString*)key first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    
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

- (void)getSharesWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure {
    [self callListingGetEndpointWithPath:SHARE_METHOD params:nil first:first last:last success:success failure:failure];
}


@end
