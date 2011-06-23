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
-(id)toListFromArray:(NSArray *)itemArray forProtocol:(Protocol *)protocol
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:10];
    
    for(id item in itemArray)
    {
        
        if ([item isKindOfClass:[NSArray class]]) 
        {
            [array addObject:[self toListFromArray:(NSArray *)item forProtocol:protocol]];  
        }
        else if([item isKindOfClass:[NSDictionary class]])
        {
            
            [array addObject:[_factory createObjectFromDictionary:(NSDictionary*)item  forProtocol:protocol]];
            
        }
        else
        {
            
            [array addObject:item];
        }
        
    }
    
    return  array;
    
}

-(id)toObjectfromString:(NSString *)JSONString forProtocol:(Protocol *)protocol
{
    id collectionObject = [JSONString objectFromJSONString];
    
    if ([collectionObject isKindOfClass:[NSArray class]]) 
    {
        return [self toListFromArray:(NSArray *)collectionObject forProtocol:protocol];   
    }
    else if([collectionObject isKindOfClass:[NSDictionary class]])
    {
        
        return [_factory createObjectFromDictionary:(NSDictionary*)collectionObject forProtocol:protocol];
        
    }
    
    return  nil;
}


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
