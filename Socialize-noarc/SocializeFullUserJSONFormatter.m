/*
 * SocializeFullUserJSONFormatter.m
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

#import "SocializeFullUserJSONFormatter.h"
#import "SocializeFullUser.h"

@implementation SocializeFullUserJSONFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeFullUser> toUser = (id<SocializeFullUser>)toObject;
    
    [toUser setObjectID: [[JSONDictionary valueForKey:@"id"]intValue]];
    [toUser setFirstName: TYPE_CHECK([JSONDictionary valueForKey:@"first_name"])];
    [toUser setLastName: TYPE_CHECK([JSONDictionary valueForKey:@"last_name"])];
    [toUser setUserName: TYPE_CHECK([JSONDictionary valueForKey:@"username"])];
    
    [toUser setDescription: TYPE_CHECK([JSONDictionary valueForKey:@"description"])];
    [toUser setSex:TYPE_CHECK([JSONDictionary valueForKey:@"sex"])];
    [toUser setLocation: TYPE_CHECK([JSONDictionary valueForKey:@"location"])];
    [toUser setSmallImageUrl:TYPE_CHECK([JSONDictionary valueForKey:@"small_image_uri"])];   
    [toUser setMedium_image_uri: TYPE_CHECK([JSONDictionary valueForKey:@"medium_image_uri"])];
    [toUser setLarge_image_uri: TYPE_CHECK([JSONDictionary valueForKey:@"large_image_uri"])];
    [toUser setMeta:TYPE_CHECK([JSONDictionary valueForKey:@"meta"])];
    
    NSDictionary* stats = TYPE_CHECK([JSONDictionary valueForKey:@"stats"]);
    if(stats != nil)
    {
        [toUser setViews:[[stats valueForKey:@"views"]intValue]];
        [toUser setLikes:[[stats valueForKey:@"likes"]intValue]];
        [toUser setComments:[[stats valueForKey:@"comments"]intValue]];
        [toUser setShare:[[stats valueForKey:@"shares"]intValue]];
    }
    
    [toUser setThirdPartyAuth:TYPE_CHECK([JSONDictionary valueForKey:@"third_party_auth"])];
    
    [super doToObject:toObject fromDictionary:JSONDictionary];
}

-(void)doToDictionary:(NSMutableDictionary *)JSONFormatDictionary fromObject:(id<SocializeObject>) fromObject
{
    id<SocializeFullUser> fromFullUser = (id<SocializeFullUser>)fromObject;
    if([fromFullUser firstName])
        [JSONFormatDictionary setObject:[fromFullUser firstName] forKey:@"first_name"];
    if([fromFullUser lastName])
        [JSONFormatDictionary setObject:[fromFullUser lastName] forKey:@"last_name"];
    
    if([fromFullUser userName])
        [JSONFormatDictionary setObject:[fromFullUser userName] forKey:@"username"];
    
    if([fromFullUser description])
        [JSONFormatDictionary setObject:[fromFullUser description] forKey:@"description"];
    
    if([fromFullUser location])
        [JSONFormatDictionary setObject:[fromFullUser location] forKey:@"location"];

    if([fromFullUser sex])
        [JSONFormatDictionary setObject:[fromFullUser sex] forKey:@"sex"];
    
    if([fromFullUser meta])
        [JSONFormatDictionary setObject:[fromFullUser meta] forKey:@"meta"];
    
    [super doToDictionary:JSONFormatDictionary fromObject:fromObject];
}

@end
