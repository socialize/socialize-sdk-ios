//
//  SocializeEntity.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"

@protocol SocializeEntity <SocializeObject>

@required

-(NSString *)key;
-(void)setKey:(NSString *)key;

-(NSString *)name;
-(void)setName:(NSString *)name;

-(int)views;
-(void)setViews:(int)views;

-(int)likes;
-(void)setLikes:(int)likes;

-(int)comments;
-(void)setComments:(int)comments;

-(int)shares;
-(void)setShares:(int)shares;

@end


@interface SocializeEntity : SocializeObject <SocializeEntity>
{
    @private
        NSString * _key;
        NSString * _name;
        int _views; 
        int _likes;
        int _comments;
        int _shares;
}

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, assign) int views; 
@property (nonatomic, assign) int likes;
@property (nonatomic, assign) int comments;
@property (nonatomic, assign) int shares;

@end
