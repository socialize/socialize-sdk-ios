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

-(id<SocializeUserServiceDelegate>) delegate
{
    
    return  (id<SocializeUserServiceDelegate>) super.delegate;
}

-(void)setDelegate:(id<SocializeUserServiceDelegate>)userServiceDelegate
{
    
    super.delegate = userServiceDelegate;
}

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeUser);
}


-(void) usersWithIds:(NSDictionary*)dictionaryUserKeyValuePairs
{
    
    [self ExecuteGetRequestAtEndPoint:USER_GET_ENDPOINT  WithParams:dictionaryUserKeyValuePairs];
}

-(void) userWithId:(int)userId
{
    [self usersWithIds:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:userId] forKey:@"id"]];
}

-(void) currentUser
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:kSOCIALIZE_USERID_KEY])
    {
         [self userWithId: [[defaults objectForKey:kSOCIALIZE_USERID_KEY] intValue]];
    }
}

-(void) updateUser:(id<SocializeUser>)user
{
    [self ExecutePostRequestAtEndPoint:USER_POST_ENDPOINT WithObject:user];
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

-(void)doDidReceiveSocializeObject:(id<SocializeObject>)objectResponse
{
   [self.delegate userService:self didReceiveUser:(id<SocializeUser>)objectResponse];
}
-(void)doDidReceiveReceiveListOfObjects:(NSArray *)objectResponse
{ [self.delegate userService:self didReceiveListOfUsers:objectResponse]; }

-(void)doDidFailWithError:(NSError *)error
{
    [self.delegate userService:self didFailWithError:error];
}

@end
