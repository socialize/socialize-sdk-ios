//
//  SocializeShareService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeObjectFactory.h"
#import "SocializeEntity.h"
#import "SocializeRequest.h"
#import "SocializeService.h"

@protocol SocializeShare;

@interface SocializeShareService : SocializeService {
}


-(void)createShareForEntityKey:(NSString*)key medium:(SocializeShareMedium)medium  text:(NSString*)text;
-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(SocializeShareMedium)medium  text:(NSString*)text;
- (void)createShare:(id<SocializeShare>)share;

@end
