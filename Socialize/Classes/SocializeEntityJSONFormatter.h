//
//  SocializeEntityJSONFormatter.h
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjectJSONFormatter.h"
#import "SocializeEntity.h"

@interface SocializeEntityJSONFormatter : SocializeObjectJSONFormatter 
{
    
}


-(void)toEntity:(id<SocializeEntity>)toEntity fromDictionary:(NSDictionary *)JSONString;

-(void)toDictionary:(NSMutableDictionary *)JSONDictionary  fromEntity:(id<SocializeEntity>)fromEntity;
@end
