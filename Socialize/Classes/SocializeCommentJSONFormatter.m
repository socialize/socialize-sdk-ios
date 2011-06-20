/*
 * SocializeCommentJSONFormatter.m
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

#import "SocializeCommentJSONFormatter.h"
#import "JSONKit.h"
#import "SocializeComment.h"
#import "SocializeObjectFactory.h"
#import "SocializeEntityJSONFormatter.h"
#import "SocializeApplicationJSONFormatter.h"
#import "SocializeUserJSONFormatter.h"

#define IDS_KEY @"ids"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"
#define COMMENT_KEY @"text"

@interface SocializeCommentJSONFormatter()
@end

@implementation SocializeCommentJSONFormatter


#pragma mark Socialize object json formatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeComment> comment = (id<SocializeComment>)toObject;
    
    [comment setObjectID: [[JSONDictionary valueForKey:@"id"]intValue]];
    [comment setText:[JSONDictionary valueForKey:@"text"]];
    
    NSDateFormatter* df = [[NSDataDetector alloc] init];
    [comment setDate:[df dateFromString:[JSONDictionary valueForKey:@"date"]]];
    [df release]; df = nil;
    
    [comment setLat:[[JSONDictionary valueForKey:@"lat"]floatValue]];
    [comment setLng:[[JSONDictionary valueForKey:@"lng"]floatValue]];
    
    SocializeEntityJSONFormatter* entityFormatter = [[SocializeEntityJSONFormatter alloc] initWithFactory:_factory];
    id<SocializeEntity> entity = [_factory createObjectForProtocolName:@"SocializeEntity"];
    [entityFormatter toObject:entity fromDictionary:[JSONDictionary valueForKey:@"entity"]];
    [comment setEntity:entity];
    [entityFormatter release]; entityFormatter = nil;
    
    SocializeApplicationJSONFormatter* appFormatter = [[SocializeApplicationJSONFormatter alloc] initWithFactory:_factory];
    id<SocializeApplication> app = [_factory createObjectForProtocolName:@"SocializeApplication"];
    [appFormatter toObject:app fromDictionary:[JSONDictionary valueForKey:@"application"]];
    [comment setApplication:app];
    [appFormatter release]; appFormatter = nil;
    
    SocializeUserJSONFormatter* userFormatter = [[SocializeUserJSONFormatter alloc] initWithFactory:_factory];
    id<SocializeUser> user = [_factory createObjectForProtocolName:@"SocializeUser"];
    [userFormatter toObject:user fromDictionary:[JSONDictionary valueForKey:@"user"]];
    [comment setUser:user];
    [userFormatter release]; userFormatter = nil;
}

@end
