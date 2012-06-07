//
//  SocializeApplication.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"

/**
 Protocol for socialize application representation.
 */
@protocol  SocializeApplication<SocializeObject>
/**Get application name*/
-(NSString * )name;
/**
 Set application name.
 @param name Application name.
 */
-(void)setName:(NSString *)name;

@end


/** Private implementation of <SocializeApplication> protocol*/
@interface SocializeApplication : SocializeObject <SocializeApplication>
{
    NSString * _name;
}

/**Set\get application name.*/
@property(nonatomic, copy) NSString * name;
@end

