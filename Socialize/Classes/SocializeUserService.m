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
#import "JSONKit.h"

#define USER_GET_ENDPOINT     @"user/"
#define USER_POST_ENDPOINT(userid)  [NSString stringWithFormat:@"user/%d/", userid]

@implementation SocializeUserService

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeFullUser);
}


-(void) getUsersWithIds:(NSArray*)ids
{
    NSDictionary* params = [NSDictionary dictionaryWithObject:ids forKey:@"id"];
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:USER_GET_ENDPOINT
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]
     ];
}

-(void) getUserWithId:(int)userId
{
    [self getUsersWithIds:[NSArray arrayWithObjects:[NSNumber numberWithInt:userId], nil]];
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
        [self executeRequest:request];
    });
}

@end
