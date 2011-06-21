//
//  SocializeEntityService.m
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeEntityService.h"


@implementation SocializeEntityService

-(void)entityWithKey:(NSString *)keyOfEntity
{
    
}

-(void)listEntitiesWithKeys:(NSArray *)entityKeysArray
{
    
}

-(void)createEntity:(id<SocializeEntity>)entity
{
    
    [self createEntityWithKey:entity.key andName:entity.name];
}

-(void)createEntityWithKey:(NSString *)keyOfEntity andName:(NSString *)nameOfEntity
{
    
}

@end
