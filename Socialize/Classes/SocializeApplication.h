//
//  SocializeApplication.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"

@protocol  SocializeApplication<SocializeObject>

-(NSString * )name;
-(void)setName:(NSString *)name;

@end


@interface SocializeApplication : SocializeObject <SocializeApplication>
{
    NSString * _name;
}

@property(nonatomic, retain) NSString * name;
@end
