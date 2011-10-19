//
//  SocializeActivityService.m
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityService.h"
#import "SocializeActivity.h"

@implementation SocializeActivityService

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeActivity);
}


-(void) getActivityOfCurrentApplication;
{
    [self getActivityOfCurrentApplicationWithFirst:nil last:nil];
}

-(void) getActivityOfCurrentApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last
{
    NSMutableDictionary* params = nil;
    
    if (first && last)
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: first, @"first", last, @"last", nil];

    
    [self executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"activity/"
                          expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                      params:params]
     ];
}

@end
