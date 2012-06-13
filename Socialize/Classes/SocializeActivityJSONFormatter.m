/*
 * SocializeActivityJSONFormatter.m
 * SocializeSDK
 *
 * Created on 10/19/11.
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

#import "SocializeActivityJSONFormatter.h"
#import "SocializeObjectFactory.h"
#import "SocializeObjects.h"

@implementation SocializeActivityJSONFormatter

// Application: [I]
// Entity: [IO]
// User: [I]
// Lat: [IO]
// Lng: [IO]
// Date: [I]

-(void)doToObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary
{
    id<SocializeActivity> activity = (id<SocializeActivity>)toObject;
    
    [activity setObjectID: [[JSONDictionary valueForKey:@"id"]intValue]];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [activity setDate:[df dateFromString:[JSONDictionary valueForKey:@"date"]]];
    [df release]; df = nil;
    
    NSNumber* lat = [JSONDictionary valueForKey:@"lat"];
    NSNumber* lng = [JSONDictionary valueForKey:@"lng"];
    
    if ([lat isKindOfClass:[NSNumber class]])
        [activity setLat:lat];
    
    if ([lng isKindOfClass:[NSNumber class]])
        [activity setLng:lng];
    
    [activity setEntity:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"entity"] forProtocol:@protocol(SocializeEntity)]];
    
    [activity setApplication:[_factory createObjectFromDictionary: [JSONDictionary valueForKey:@"application"] forProtocol:@protocol(SocializeApplication)]];
    
    [activity setUser:[_factory createObjectFromDictionary:[JSONDictionary valueForKey:@"user"] forProtocol:@protocol(SocializeUser)]];
    
    [activity setPropagationInfoResponse:[JSONDictionary valueForKey:@"propagation_info_response"]];
    
    [super doToObject:toObject fromDictionary:JSONDictionary];
}

- (void)doToDictionary:(NSMutableDictionary *)dictionaryRepresentation fromObject:(id<SocializeObject>)fromObject {
    
    id<SocializeActivity> activity = (id<SocializeActivity>)fromObject;
    
    [dictionaryRepresentation setValue:[activity lat] forKey:@"lat"];
    [dictionaryRepresentation setValue:[activity lng] forKey:@"lng"];
    
    id<SocializeEntity> entity = [activity entity];
    if ([[entity name] length] > 0) {
        NSMutableDictionary *entityParams = [NSMutableDictionary dictionary];
        [entityParams setObject:[entity key] forKey:@"key"];
        [entityParams setObject:[entity name] forKey:@"name"];
        [dictionaryRepresentation setObject:entityParams forKey:@"entity"];
    } else {
        [dictionaryRepresentation setObject:[entity key] forKey:@"entity_key"];
    }
    
    if ([activity propagation] != nil) {
        [dictionaryRepresentation setObject:[activity propagation] forKey:@"propagation"];
    }

    if ([activity propagationInfoRequest] != nil) {
        [dictionaryRepresentation setObject:[activity propagationInfoRequest] forKey:@"propagation_info_request"];
    }

    [super doToDictionary:dictionaryRepresentation fromObject:fromObject];
}


@end
