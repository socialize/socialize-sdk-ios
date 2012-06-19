//
//  SocializeActivityService.m
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityService.h"
#import "SocializeActivity.h"
@interface SocializeActivityService()
-(NSString*)resourcePathWithUserId: (int)identificator andActivityType:(SocializeActivityType) type;
@end

@implementation SocializeActivityService

- (void)callActivityGetWithParams:(NSMutableDictionary*)params success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [self callEndpointWithPath:@"activity/" method:@"GET" params:params success:success failure:failure];
}

- (void)getActivityOfApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:first forKey:@"first"];
    [params setValue:last forKey:@"last"];
    
    [self callActivityGetWithParams:params success:success failure:failure];
}

- (void)getActivityOfEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:first forKey:@"first"];
    [params setValue:last forKey:@"last"];
    [params addEntriesFromDictionary:SZServerParamsForEntity(entity)];
    
    [self callActivityGetWithParams:params success:success failure:failure];
}

-(NSString*)resourcePathWithUserId: (int)identificator andActivityType:(SocializeActivityType) type
{
    NSString* resourcePath = nil;
    switch (type) {
        case SocializeCommentActivity:
            resourcePath = [NSString stringWithFormat:@"user/%d/comment/", identificator];            
            break;
        case SocializeLikeActivity:
            resourcePath = [NSString stringWithFormat:@"user/%d/like/", identificator];            
            break;
        case SocializeShareActivity:
            resourcePath = [NSString stringWithFormat:@"user/%d/share/", identificator];            
            break;
        case SocializeViewActivity:
            resourcePath = [NSString stringWithFormat:@"user/%d/view/", identificator];            
            break;
            
        default:
            resourcePath = [NSString stringWithFormat:@"user/%d/activity/", identificator];
            break;
    }
    return resourcePath;
}

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeActivity);
}


-(void) getActivityOfCurrentApplication;
{
    [self getActivityOfCurrentApplicationWithFirst:nil last:nil];
}

-(void) getActivityOfCurrentApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last
{
    NSMutableDictionary* params = nil;
    
    if (first && last)
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: first, @"first", last, @"last", nil];

    
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"activity/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];
}

-(void) getActivityOfUserId:(NSInteger)userId {
    return [self getActivityOfUserId:userId first:nil last:nil activity:SocializeAllActivity];
}

-(void) getActivityOfUser:(id<SocializeUser>)user
{
    [self getActivityOfUser:user first:nil last:nil activity:SocializeAllActivity];
}

-(void) getActivityOfUser:(id<SocializeUser>)user first: (NSNumber*)first last:(NSNumber*)last activity: (SocializeActivityType) type
{
    [self getActivityOfUserId:user.objectID first:first last:last activity:type];
}

-(void) getActivityOfUserId:(NSInteger)userId first: (NSNumber*)first last:(NSNumber*)last activity: (SocializeActivityType) type
{
    NSMutableDictionary* params = nil;
    
    if (first && last)
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: first, @"first", last, @"last", nil];
    

    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:[self resourcePathWithUserId: userId andActivityType: type]
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];   
}

@end
