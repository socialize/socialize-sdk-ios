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
#import "SocializeService.h"

@interface SocializeViewService : SocializeService {

}

-(void)createViewForEntityKey:(NSString*)key;
-(void)createViewForEntity:(id<SocializeEntity>)entity;

@end