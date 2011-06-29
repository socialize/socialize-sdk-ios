//
//  DemoEntry.m
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/6/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "DemoEntity.h"

#define DEMO_KEY @"http:////www.google.com"

@implementation DemoEntity

@synthesize socializeEntry = _entry;
@synthesize entryContext = _entryContext;

-(id) initWithSocializeEntry: (SocializeEntity*) sEntry entryContext: (NSString*) eContext
{
    self = [super init];

    if(self != nil)
    {
        self.socializeEntry = sEntry;
        self.entryContext = eContext;
    }
    
    return self;
}

-(void) dealloc
{
    [_entry release];
    [_entryContext release];
    [super dealloc];
}

+(DemoEntity*) createDemoEntryWithText: (NSString*) text
{
    SocializeEntity* entry = [[SocializeEntity alloc] init];
    entry.key = DEMO_KEY;
    entry.name = @"Google";
    entry.views = 11;
    entry.likes = 7;
    entry.comments = 0;
    
    DemoEntity* demoEntry = [[[DemoEntity alloc] initWithSocializeEntry:entry entryContext:text] autorelease];
    
    [entry release];
    return demoEntry;
}

@end
