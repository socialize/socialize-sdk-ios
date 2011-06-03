//
//  SocializeObjectFactory.h
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SocializeConfiguration;
@interface SocializeObjectFactory : NSObject 
{
    @protected
        NSMutableDictionary * prototypeDictionary; 
}

-(id)initializeWithConfiguration:(SocializeConfiguration*)configuration;
-(id)createObject:(NSString *)protocolName;
-(void)addPrototype:(Class)socializeObjectPrototype forKey:(NSString *)protocolName;
-(id)createObjectForProtocol:(Protocol *)protocol;
@end
