/*
 * SocializeApplicationJSONFormatter.m
 * SocializeSDK
 *
 * Created on 6/20/11.
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

#import "SocializeApplicationJSONFormatter.h"


@implementation SocializeApplicationJSONFormatter

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeApplication> toApplication = (id<SocializeApplication>)toObject;
    
    [toApplication setObjectID: [[JSONDictionary valueForKey:@"id"]intValue]];
    [toApplication setName:[JSONDictionary valueForKey:@"name"]];   
}

-(void)doToDictionary:(NSMutableDictionary *)JSONFormatDictionary fromObject:(id<SocializeObject>) fromObject
{
    id<SocializeApplication> fromApplication = (id<SocializeApplication>)fromObject;
    
    [JSONFormatDictionary setObject:[NSNumber numberWithInt:fromApplication.objectID] forKey:@"id"];
    [JSONFormatDictionary setObject:fromApplication.name forKey:@"name"];
}

@end
