//
//  SocializeObject.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 In progress
 */
@protocol SocializeObject <NSObject>

-(int) objectID;
-(void) setObjectID:(int)objectID;

@end


@interface SocializeObject : NSObject <SocializeObject>
{
    @private 
        int _objectID;
}

@property(nonatomic, assign) int objectID;

@end
