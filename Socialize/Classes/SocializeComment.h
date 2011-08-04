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
 In progress
 */
@protocol SocializeComment <SocializeActivity>

-(NSString *)text;
-(void)setText:(NSString *)text;

@end

@interface SocializeComment : SocializeActivity <SocializeComment>
{
   NSString * _text;
}

@property (nonatomic, retain) NSString * text;

@end
