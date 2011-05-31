//
//  SocializeObjectParser.h
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SocializeObject;
@class  SocializeObjectFactory;

@interface SocializeObjectParser : NSObject 
{
    @protected
        SocializeObjectFactory * _factory;
}
-(id)initWithFactory:(SocializeObjectFactory *) theObjectFactory;
-(void)toObject:(id<SocializeObject>) toObject From:(id)dataToParse;
-(id)fromObject:(id<SocializeObject>) fromObject;
@end
