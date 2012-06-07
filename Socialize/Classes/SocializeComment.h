//
//  SocializeComment.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeActivity.h"

/**
 Protocol for sosialize comment representation.
 */
@protocol SocializeComment <SocializeActivity>

/**Get comment text*/
-(NSString *)text;
/**
 Set comment text
 @param text Comment text for an entity.
 */
-(void)setText:(NSString *)text;

-(BOOL)subscribe;
/**
 Set subscribed
 @param subscribe If yes, subscribe user to push notifications for new comments on the entity
 */
-(void)setSubscribe:(BOOL)subscribe;

@end

/**Private implementation of <SocializeComment> protocol.*/
@interface SocializeComment : SocializeActivity <SocializeComment>
{
   NSString * _text;
}

/**Comment text*/
@property (nonatomic, copy) NSString * text;
@property (nonatomic, assign) BOOL subscribe;

+ (SocializeComment*)commentWithEntity:(id<SocializeEntity>)entity text:(NSString*)text;

@end

