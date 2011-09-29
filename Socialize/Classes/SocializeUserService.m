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

@interface SocializeUserService ()
    -(void) usersWithIds:(NSDictionary*)dictionaryUserKeyValuePairs;
@end 
@implementation SocializeUserService

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeUser);
}


-(void) usersWithIds:(NSDictionary*)dictionaryUserKeyValuePairs
{
    [self ExecuteGetRequestAtEndPoint:USER_GET_ENDPOINT  WithParams:dictionaryUserKeyValuePairs expectedResponseFormat:SocializeDictionaryWIthListAndErrors ];
}

-(void) userWithId:(int)userId
{
    [self usersWithIds:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:userId] forKey:@"id"]];
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

-(void) updateUser:(id<SocializeUser>)user
{
    [self ExecutePostRequestAtEndPoint:USER_POST_ENDPOINT WithObject:user expectedResponseFormat:SocializeDictionary];
}

//-(void) createUserWithFirstname:(NSString *)firstName lastName:(NSString *)lastName description:(NSString *) description location:(NSString *) location
//                        picture:(NSData *)pictureData
//{
//    id<SocializeUser> user = (id<SocializeUser>)[self newObject];
//    user.firstName = firstName;
//    user.lastName = lastName;
//    user.description = description;
//    [self updateUser:user];
//    
//}

@end
