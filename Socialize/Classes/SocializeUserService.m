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
#import "SocializeCommonDefinitions.h"


#define USER_GET_ENDPOINT     @"user/"
#define USER_POST_ENDPOINT    @"user/"

@implementation SocializeUserService

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeFullUser);
}


-(void) usersWithIds:(NSArray*)ids
{
    NSDictionary* params = [NSDictionary dictionaryWithObject:ids forKey:@"id"];
    [self ExecuteGetRequestAtEndPoint:USER_GET_ENDPOINT WithParams:params expectedResponseFormat:SocializeDictionaryWIthListAndErrors];
}

-(void) userWithId:(int)userId
{
    [self usersWithIds:[NSArray arrayWithObjects:[NSNumber numberWithInt:userId], nil]];
}

-(void) currentUser
{   
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    if (userData != nil) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        id<SocializeUser> user = [_objectCreator createObjectFromDictionary:info forProtocol:@protocol(SocializeUser)];
        [self userWithId: user.objectID];
    }
}

//-(void) updateUser:(id<SocializeFullUser>)user
//{
//    [self ExecutePostRequestAtEndPoint:USER_POST_ENDPOINT WithObject:user expectedResponseFormat:SocializeDictionary];
//}


@end
