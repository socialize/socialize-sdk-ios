//
//  SocializeObject.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Base protocol for every Socialize object.
 */
@protocol SocializeObject <NSObject>

/**
 Get unique object id.
 */
-(int) objectID;

/**
 Set unique obejct id.
 @param objectID test
 */
-(void) setObjectID:(int)objectID;

@end

/**
 Private implementation of SocializeObject protocaol.
 */
@interface SocializeObject : NSObject <SocializeObject, NSCopying>
{
    @private 
        int _objectID;
}

/**Set/get object unique identificator*/
@property(nonatomic, assign) int objectID;

@end
