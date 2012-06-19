//
//  SocializeObjectFormatter.h
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjectFormatter.h"

@protocol SocializeObject;

#define TYPE_CHECK(value) [self nullCheck:(value)]

@interface SocializeObjectJSONFormatter : SocializeObjectFormatter
{   
}

-(id)nullCheck:(id)value;

//-(void)toObject:(id<SocializeObject>)toObject fromJSONString:(NSString *)JSONString;
//
////Template Methods
//-(void)toObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary;
//-(void)toDictionary:(NSMutableDictionary *)dictionary fromObject:(id<SocializeObject>) fromObject;
//-(NSString*) toStringfromObject:(id<SocializeObject>) fromObject;
//
//
////Primitive methods
//-(void)doToObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)JSONDictionary;
//-(void)doToDictionary:(NSMutableDictionary *)dictionary fromObject:(id<SocializeObject>) fromObject;
@end
