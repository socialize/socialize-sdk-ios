//
//  SocializeGetRequest.h
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeRequest.h"

@interface SocializeGetRequest : SocializeRequest 
{
    @private
        uint64_t Id;
}

@property (nonatomic) uint64_t Id; 

@end
