//
//  DemoEntry.h
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/6/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeEntity.h"

@interface DemoEntry : NSObject {
    SocializeEntity* _entry;
    NSString* _entryContext;
}

-(id) initWithSocializeEntry: (SocializeEntity*) sEntry entryContext: (NSString*) eContext;
+(DemoEntry*) createDemoEntryWithText: (NSString*) text;

@property (nonatomic, retain) SocializeEntity* socializeEntry;
@property (nonatomic, retain) NSString* entryContext;

@end