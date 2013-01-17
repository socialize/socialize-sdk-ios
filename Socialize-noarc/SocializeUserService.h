/*
 * SocializeUserService.h
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

#import <Foundation/Foundation.h>
#import "SocializeService.h"
#import "SocializeFullUser.h"
#import "SocializeRequest.h"
#import "SocializeEntity.h"

@class UIImage;
@protocol SZLike;

@interface SocializeUserService : SocializeService  
{
    
}

-(void) getUsersWithIds:(NSArray*)ids success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
-(void) getUserWithId:(int)userId;
-(void) getUsersWithIds:(NSArray*)ids;
-(void) getCurrentUser;
-(void) updateUser:(id<SocializeFullUser>)user;
-(void) updateUser:(id<SocializeFullUser>)user profileImage:(UIImage*)image;
- (void)updateUser:(id<SocializeFullUser>)user
      profileImage:(UIImage*)image
           success:(void(^)(id<SocializeFullUser> user))success
           failure:(void(^)(NSError *error))failure;

- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last;
- (void)getLikesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last;
- (void)getSharesForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
- (void)getCommentsForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
- (void)getActivityForUser:(id<SocializeUser>)user entity:(id<SocializeEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *activity))success failure:(void(^)(NSError *error))failure;
- (void)deleteLikeForUser:(id<SZFullUser>)user entity:(id<SZEntity>)entity success:(void(^)(id<SZLike>))success failure:(void(^)(NSError *error))failure;

@end


