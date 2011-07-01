//
//  SocializeViewService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeView.h"
#import "SocializeRequest.h"
#import "SocializeViewService.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeObjectFactory.h"
#import "SocializeProvider.h"

@interface SocializeViewService : NSObject<SocializeRequestDelegate> {

@private
    id<SocializeViewServiceDelegate> _delegate;
    SocializeProvider                *_provider;
    SocializeObjectFactory           *_objectCreator;
}

@property (nonatomic, assign) id<SocializeViewServiceDelegate> delegate;
@property (nonatomic, retain) SocializeProvider                *provider;
@property (nonatomic, retain) SocializeObjectFactory           *objectCreator;

-(void)createViewForEntityKey:(NSString*)key;
-(void)createViewForEntity:(id<SocializeEntity>)entity;
-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeViewServiceDelegate>) delegate;
@end