//
//  POOCObjectFactory.h
//  SocializeSDK
//
//  Created by William Johnson on 5/17/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SocializeConfiguration;
@interface SocializePOOCObjectFactory : NSObject 
{
    @private
    NSMutableDictionary * prototypeDictionary; 
}

-(id)initializeWithConfiguration:(SocializeConfiguration*)configuration;
-(id)createObject:(NSString *)protocolName;
-(void)addPrototype:(Class)socializeObjectPrototype forKey:(NSString *)protocolName;

@end
