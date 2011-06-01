//
//  SocializeService.h
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocializeObject;


@protocol  SocializeServiceDelegate;

@interface SocializeService : NSObject 
{
    
}

@end
-(SocializeRequest *)getObject



@protocol SocializeServiceDelegate

-(void)socializeService:(SocializeService *)service didAuthenticateWithSession:(SocializeSession *)session;
-(void)socializeService:(SocializeService *)service did:id<SocializeObject> object error:(NSError *) error;
-(void)socializeService:(SocializeService *)service didListObjects:(NSArray *)objectlist;
-(void)socializeService:(SocializeService *)service didPostObjects:(NSArray *)objectlist;

@end
