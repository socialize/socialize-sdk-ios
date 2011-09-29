/*
 * SocializeFullUser.m
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

#import "SocializeFullUser.h"


@implementation SocializeFullUser

@synthesize firstName = _firstName;
@synthesize lastName =  _lastName;
@synthesize userName = _userName;
@synthesize smallImageUrl = _smallInageUrl;
@synthesize description = _description;
@synthesize location = _location;
@synthesize medium_image_uri = _medium_image_uri;
@synthesize large_image_uri = _large_image_uri;
@synthesize sex = _sex;
@synthesize meta = _meta;

@synthesize views = _views;
@synthesize likes = _likes;
@synthesize comments = _comments;
@synthesize share = _share;

@synthesize thirdPartyAuth = _thirdPartyAuth;

-(NSNumber*)detectUserIdWithTag: (NSString*) tag
{
    NSNumber* result = nil;
    for(NSDictionary* info in _thirdPartyAuth)
    {
        if([[info objectForKey:@"auth_type"] isEqual:tag])
            result = [info objectForKey:@"auth_id"];
    }
    return [[result copy] autorelease];
}

-(NSNumber*)userIdForThirdPartyAuth:(ThirdPartyAuthName) auth
{
    NSNumber* userId = nil;
    switch (auth) {
        case FacebookAuth:
            userId = [self detectUserIdWithTag: @"FaceBook"];
            break;
    }
    return userId;
}
@end