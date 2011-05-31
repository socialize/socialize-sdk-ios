//
//  SocializeObjectFormatter.h
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SocializeObject;
@class  SocializeObjectFactory;

@interface SocializeObjectJSONFormatter : NSObject 
{
    @protected
        SocializeObjectFactory * _factory;
}
-(id)initWithFactory:(SocializeObjectFactory *) theObjectFactory;

//-(void)toObject:(id<SocializeObject>) toObject fromJSONString:(NSString *)JSONDictionary;
//-(NSString *)fromObjectToJSONString:(id<SocializeObject>) fromObject;

//Template Methods
-(void)toObject:(id<SocializeObject>) toObject fromDictionary:(NSDictionary *)JSONDictionary;
-(NSDictionary *)fromObject:(id<SocializeObject>) fromObject;


//Primitive methods
-(void)doToObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)JSONDictionary;
-(NSDictionary *)doFromObject:(id<SocializeObject>) fromObject;
@end
