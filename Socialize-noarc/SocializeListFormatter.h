//
//  SocializeListFormatter.h
//  SocializeSDK
//
//  Created by William M. Johnson on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjectJSONFormatter.h"

@interface SocializeListFormatter: SocializeObjectFormatter 
{
    
}

-(id)toObjectfromString:(NSString *)JSONString forProtocol:(Protocol *)protocol;
//-(void)toObjectArray:(NSMutableArray *)objectList fromString:(NSString *)JSONString;
//-(void)toObjectArray:(NSMutableArray *)objectList fromDictionaryArray:(NSArray *)arrayOfDictionaries;

//Template Methods
-(void)toRepresentationArray:(NSMutableArray *)JSONArray fromArray:(NSArray *)objectArray;
-(NSString*)toRepresentationStringfromArray:(NSArray *)objectArray;

//Primitive methods


@end
