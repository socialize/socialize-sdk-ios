//
//  SocializeListFormatter.m
//  SocializeSDK
//
//  Created by William M. Johnson on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeListFormatter.h"
#import "SocializeObject.h"
#import "SocializeObjectFactory.h"
#import "JSONKit.h"


@implementation SocializeListFormatter

//-(void)toObjectArray:(NSMutableArray *)objectList fromString:(NSString *)JSONString
//{
//    
//    
//}
//
//-(void)toObjectArray:(NSMutableArray *)objectList fromDictionaryArray:(NSArray *)JSONArrayOfDictionaries
//{
//    
//    
//}

//Template Methods

-(void)toRepresentationArray:(NSMutableArray *)JSONArray fromArray:(NSArray *)objectArray
{
    
    for(id item in objectArray)
    {
        
        if ([item conformsToProtocol:@protocol(SocializeObject)]) 
        {
           
            [JSONArray addObject:[_factory createDictionaryRepresentationOfObject:(id<SocializeObject>)item]];  
            
        } 
        //No need to check for other object types, or well . . we probably should check.  If it is not Array, Dictionary, or NSNumber
        //The JSON parser will throw an error.  We should funnel this error to the user.
        else 
        {
            
            [JSONArray addObject:item];
            
        }
    }
}

-(NSString*) toRepresentationStringfromArray:(NSArray *)objectArray
{
 
    NSMutableArray * JSONArray = [[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    [self toRepresentationArray:JSONArray fromArray:objectArray];
    
    NSString * jsonString = [JSONArray JSONString];
    NSAssert(jsonString != nil, @"String should not be nil");
    
    return  jsonString;
}


//Primitive methods


@end
