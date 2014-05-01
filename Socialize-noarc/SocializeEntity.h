//
//  SocializeEntity.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"
#import "SocializeCommonDefinitions.h"

/**
 Protocol for socialize entity representation.
 */
@protocol SocializeEntity <SocializeObject>

@required

/**Get unique key (URL) of entity.*/
-(NSString *)key;
/**Set unique key (URL) of entity.
 @param key Entity URL*/
-(void)setKey:(NSString *)key;

/**Get entity name.*/
-(NSString *)name;
/**
 Set entity name.
 @param name Entity's name
 */
-(void)setName:(NSString *)name;

-(NSString *)type;
-(void)setType:(NSString *)type;

/**Get views' count*/
-(int)views;

/**Get views' count
 @param views Views' count.
 */
-(void)setViews:(int)views;

/**Get likes' count*/
-(int)likes;
/**Set likes' count.
 @name likes Likes' count.
 */
-(void)setLikes:(int)likes;

/**Get comments' count*/
-(int)comments;
/**Get comments's count.
 @param comments Comments's count.
 */
-(void)setComments:(int)comments;

/**Get shares' count*/
-(int)shares;
/**Set shares' count
 @param shares Shares' count
 */
-(void)setShares:(int)shares;

/**Get metadata of entity.*/
-(NSString *)meta;
/**Set metadata of entity.
 @param meta freeform metadata string */
-(void)setMeta:(NSString *)meta;

-(NSDictionary*)userActionSummary;
-(void)setUserActionSummary:(NSDictionary*)userActionSummary;

- (NSString*)displayName;

/**YES if key is a valid URL String*/
- (BOOL)keyIsURL;

@end

/**Private implementation of <SocializeEntity> protocol*/
@interface SocializeEntity : SocializeObject <SocializeEntity>
{
    @private
        NSString * _key;
        NSString * _name;
        int        _views; 
        int        _likes;
        int        _comments;
        int        _shares;
}

/**Entity key*/
@property (nonatomic, copy) NSString * key;
/**Entity name*/
@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * type;

/**Views' count*/
@property (nonatomic, assign) int views; 
/**Likes' count*/
@property (nonatomic, assign) int likes;
/**Comments' count*/
@property (nonatomic, assign) int comments;
/**Shares's count*/
@property (nonatomic, assign) int shares;

/**Entity metadata*/
@property (nonatomic, copy) NSString * meta;

@property (nonatomic, retain) NSDictionary * userActionSummary;

+ (SocializeEntity*)entityWithKey:(NSString*)key;
+ (SocializeEntity*)entityWithKey:(NSString*)key name:(NSString*)name;

@end

NSDictionary *SZServerParamsForEntity(id<SZEntity> entity);

BOOL SZEntityIsLiked(id<SZEntity> entity);

