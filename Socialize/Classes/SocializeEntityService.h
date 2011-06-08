//
//  SocializeEntityService.h
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeService.h"
#import "SocializeEntity.h"


@interface SocializeEntityService : NSObject 
{
    
}
-(void)entityWithKey:(NSString *)keyOfEntity;
-(void)listEntitiesWithKeys:(NSArray *)entityKeysArray;
-(void)createEntity:(id<SocializeEntity>)entity;
-(void)createEntityWithKey:(NSString *)keyOfEntity andName:(NSString *)nameOfEntity;

@end
