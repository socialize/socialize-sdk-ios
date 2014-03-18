/*
 * SocializeUserService.m
 * SocializeSDK
 *
 * Created on 6/17/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SocializeUserService.h"
#import "SocializePrivateDefinitions.h"
#import "UIImage+Network.h"
#import <SZJSONKit/JSONKit.h>
#import "SocializeEntity.h"
#import "SocializeLike.h"
#import "SocializeShare.h"
#import "SocializeView.h"
#import "socialize_globals.h"
#import "SZAPIClientHelpers.h"

#define USER_GET_ENDPOINT     @"user/"
#define USER_POST_ENDPOINT(userid)  [NSString stringWithFormat:@"user/%d/", userid]
#define USER_LIKE_ENDPOINT(userid)  [NSString stringWithFormat:@"user/%d/like/", userid]
#define USER_SHARE_ENDPOINT(userid)  [NSString stringWithFormat:@"user/%d/share/", userid]
#define USER_COMMENT_ENDPOINT(userid)  [NSString stringWithFormat:@"user/%d/comment/", userid]
#define USER_ACTIVITY_ENDPOINT(userid)  [NSString stringWithFormat:@"user/%d/activity/", userid]
#define USER_VIEW_ENDPOINT(userid)  [NSString stringWithFormat:@"user/%d/view/", userid]

@implementation SocializeUserService

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeFullUser);
}


-(void) getUsersWithIds:(NSArray*)ids success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    NSDictionary* params = [NSDictionary dictionaryWithObject:ids forKey:@"id"];
    SocializeRequest *request =      [SocializeRequest requestWithHttpMethod:@"GET"
                                                                resourcePath:USER_GET_ENDPOINT
                                                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                      params:params];
    request.successBlock = success;
    request.failureBlock = failure;

    [self executeRequest:request];
}

-(void) getUserWithId:(int)userId {
    [self getUsersWithIds:[NSArray arrayWithObjects:[NSNumber numberWithInt:userId], nil]];
}

-(void) getUsersWithIds:(NSArray*)ids {
    [self getUsersWithIds:ids success:nil failure:nil];
}

-(void) getCurrentUser
{   
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    NSAssert(userData != nil, @"Tried to get current user without authenticating first");
    NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    id<SocializeUser> user = [_objectCreator createObjectFromDictionary:info forProtocol:@protocol(SocializeUser)];
    [self getUserWithId: user.objectID];
}

-(void) updateUser:(id<SocializeFullUser>)user
{
    [self updateUser:user profileImage:nil];
}

-(void) updateUser:(id<SocializeFullUser>)user profileImage:(UIImage*)image {
    [self updateUser:user profileImage:image success:nil failure:nil];
}

- (void)updateUser:(id<SocializeFullUser>)user
      profileImage:(UIImage*)image
           success:(void(^)(id<SocializeFullUser> user))success
           failure:(void(^)(NSError *error))failure {
    
    // Build the request in the background, as profile image can be large
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* userResource = USER_POST_ENDPOINT(user.objectID);
        
        NSMutableDictionary * jsonParams =  [[[_objectCreator createDictionaryRepresentationOfObject:user] mutableCopy] autorelease];
        if (image != nil) {
            NSString *imageb64 = [image base64PNGRepresentation];
            if (imageb64 != nil) {
                [jsonParams setObject:[image base64PNGRepresentation] forKey:@"picture"];
            }
        }
        
        NSString *json = [jsonParams JSONString];
        NSMutableDictionary* params = [self generateParamsFromJsonString:json];
        SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                                                               resourcePath:userResource
                                                         expectedJSONFormat:SocializeDictionary
                                                                     params:params];
        request.operationType = SocializeRequestOperationTypeUpdate;
        request.successBlock = ^(id<SZFullUser> newUser) {
            SZHandleUserChange(newUser);
            BLOCK_CALL_1(success, newUser);
        };
        request.failureBlock = failure;
        
        [self executeRequest:request];
    });

}

- (void)getActivityForEndpoint:(NSString*)endpoint protocol:(Protocol*)protocol user:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (entity != nil) {
        [params setObject:[entity key] forKey:@"entity_key"];
    }
    
    [params setValue:first forKey:@"first"];
    [params setValue:last forKey:@"last"];
    
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"GET"
                                                           resourcePath:endpoint
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    
    request.expectedProtocol = protocol;
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [self getActivityForEndpoint:USER_LIKE_ENDPOINT([user objectID]) protocol:@protocol(SocializeLike) user:user entity:entity first:first last:last success:success failure:failure];
}

- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last {
    [self getLikesForUser:user entity:entity first:first last:last success:nil failure:nil];
}

- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [self getActivityForEndpoint:USER_SHARE_ENDPOINT([user objectID]) protocol:@protocol(SocializeShare) user:user entity:entity first:first last:last success:success failure:failure];
}

- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last {
    [self getSharesForUser:user entity:entity first:first last:last success:nil failure:nil];
}

- (void)getCommentsForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [self getActivityForEndpoint:USER_COMMENT_ENDPOINT([user objectID]) protocol:@protocol(SocializeShare) user:user entity:entity first:first last:last success:success failure:failure];
}

- (void)getActivityForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure {
    [self getActivityForEndpoint:USER_ACTIVITY_ENDPOINT([user objectID]) protocol:@protocol(SocializeActivity) user:user entity:entity first:first last:last success:success failure:failure];
}

- (void)deleteLikeForUser:(id<SZFullUser>)user entity:(id<SZEntity>)entity success:(void(^)(id<SZLike>))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = [NSDictionary dictionaryWithObject:[entity key] forKey:@"entity_key"];
    
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"DELETE"
                                                           resourcePath:USER_LIKE_ENDPOINT([user objectID])
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    request.successBlock = ^(NSArray *likes) {
        id<SZLike> like = nil;
        if ([likes count] > 0) {
            like = [likes objectAtIndex:0];
        }
        BLOCK_CALL_1(success, like);
    };
    request.failureBlock = failure;

    request.expectedProtocol = @protocol(SZLike);
    
    [self executeRequest:request];
}



@end
