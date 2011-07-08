//
//  SocializeShareService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareService.h"

@interface SocializeShareService()
@end


#define SHARE_METHOD @"share/"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"

@implementation SocializeShareService

-(void) dealloc
{
    [super dealloc];
}

-(void)createShareForEntity:(id<SocializeEntity>)entity medium:(ShareMedium)medium  text:(NSString*)text{
    DLog(@"entity %@", entity);
    [self createShareForEntityKey:[entity key] medium:medium text:text];
}

-(void)createShareForEntityKey:(NSString*)key medium:(ShareMedium)medium  text:(NSString*)text{
    
    if (key && [key length]){   
        NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:key, @"entity", text, @"text", [NSNumber numberWithInt:medium], @"medium" , nil];
        NSArray *params = [NSArray arrayWithObjects:entityParam, 
                           nil];
        [_provider requestWithMethodName:SHARE_METHOD andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:self];
    }
}


@end
