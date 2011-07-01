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
#import "SocializeProvider.h"
#import "SocializeEntity.h"
#import "SocializeRequest.h"

typedef enum {
    Facebook = 1,
    Twitter = 2,
    Other = 3
} ShareMedium;


@interface SocializeShareService : NSObject<SocializeRequestDelegate> {
    @private
    id<SocializeShareServiceDelegate> _delegate;
    SocializeProvider                *_provider;
    SocializeObjectFactory           *_objectCreator;
}

@property (nonatomic, assign) id<SocializeShareServiceDelegate> delegate;
@property (nonatomic, retain) SocializeProvider                *provider;
@property (nonatomic, retain) SocializeObjectFactory           *objectCreator;

-(void)createShareForEntityKey:(NSString*)key medium:(ShareMedium)medium  text:(NSString*)text;
-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(ShareMedium)medium  text:(NSString*)text;
-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeShareServiceDelegate>)delegate;

@end
