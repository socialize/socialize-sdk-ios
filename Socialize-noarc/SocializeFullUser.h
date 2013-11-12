/*
 * SocializeFullUser.h
 * SocializeSDK
 *
 * Created on 9/29/11.
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
#import "SocializeObject.h"
#import "SocializeCommonDefinitions.h"


/**Protocol for socialize user representation.*/
@protocol SocializeFullUser<SocializeObject>

@required

-(void) setFirstName: (NSString*) firstName;
-(NSString*) firstName;

-(void) setLastName: (NSString*) lastName;
-(NSString*) lastName;

-(void) setUserName: (NSString*) userName;
-(NSString*) userName;

-(NSString*) displayName;

-(void) setDescription: (NSString*)description;
-(NSString*)description;

-(void) setSex: (NSString*)sex;
-(NSString*)sex;

-(void) setLocation: (NSString*) location;
-(NSString*)location;

-(void) setSmallImageUrl: (NSString*) smallImageUrl;
-(NSString*)smallImageUrl;

-(void)setMedium_image_uri: (NSString*)mediumImageUrl;
-(NSString*)medium_image_uri;

-(void)setLarge_image_uri: (NSString*) largeImageUrl;
-(NSString*)large_image_uri;

-(void)setMeta:(NSString*)meta;
-(NSString*)meta;

-(void) setViews: (int) views;
-(int)views;

-(void) setLikes: (int) likes;
-(int)likes;

-(void) setComments: (int) comments;
-(int)comments;

-(void)setShare: (int) share;
-(int)share;

-(void)setThirdPartyAuth:(NSArray*)auth;
-(NSArray*)thirdPartyAuth;

@end

/**Private implementation of <SocializeUser> protocol*/
@interface SocializeFullUser : SocializeObject<SocializeFullUser, NSCopying> 
{
@private
    NSString* _firstName;
    NSString* _lastName;
    NSString* _userName;    
    NSString* _description;
    NSString* _sex;
    NSString* _location;
    NSString* _smallInageUrl;
    NSString* _medium_image_uri;
    NSString* _large_image_uri;
    NSString* _meta;
    
    int _views;
    int _likes;
    int _comments;
    int _share;
    
    NSArray* _thirdPartyAuth;
}

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* sex;
@property (nonatomic, copy) NSString* location;
@property (nonatomic, copy) NSString* smallImageUrl;
@property (nonatomic, copy) NSString* medium_image_uri;
@property (nonatomic, copy) NSString* large_image_uri;
@property (nonatomic, copy) NSString* meta;

@property (nonatomic, assign) int views;
@property (nonatomic, assign) int likes;
@property (nonatomic, assign) int comments;
@property (nonatomic, assign) int share;

@property (nonatomic, copy) NSArray* thirdPartyAuth;

@end
