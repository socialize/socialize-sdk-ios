//
//  SocializeNotificationService.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//
#import "SocializeDeviceTokenService.h"
#import "SocializeRequest.h"
#import "SocializeDeviceToken.h"
#import "Socialize.h"

#define SOCIALIZE_USER_DEVICE_METHOD @"user/device/"

@implementation SocializeDeviceTokenService

@synthesize registerDeviceTimer = registerDeviceTimer_;

-(void) dealloc {
    self.registerDeviceTimer = nil;
    [super dealloc];
}
-(void)registerDeviceTokens:(NSArray *) tokens {
    NSMutableArray *params = [NSMutableArray array];
    for ( NSString *token in tokens ) {
        NSDictionary *deviceToken = [NSDictionary dictionaryWithObjectsAndKeys:
                                     token, @"device_token",
                                     @"iOS", @"device_type",
                                     nil];
        [params addObject:deviceToken];
       
    }
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"POST"
                               resourcePath:SOCIALIZE_USER_DEVICE_METHOD
                         expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                     params:params];
    [self executeRequest:request];
}
-(BOOL)shouldRegisterDeviceToken:(NSString *)deviceToken {
    NSString *storedDeviceToken = [self getDeviceToken];
    if (storedDeviceToken && [storedDeviceToken isEqualToString:deviceToken] ) {
        return NO;
    } else {
        return YES;
    }
}
-(NSString *) getDeviceToken {
    return [Socialize deviceToken];
}
-(void) invalidateRegisterDeviceTimer {
    if (self.registerDeviceTimer) {
        [self.registerDeviceTimer invalidate];
        self.registerDeviceTimer = nil;
    }   
}
// if the like is created this is called
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    //_like is object level instance of type <SocializeLike>
    NSLog(@"did create obj");
}
-(void)registerDeviceTokensWithTimer:(NSString *)deviceToken {
    if( [self shouldRegisterDeviceToken:deviceToken] ) {
        NSLog(@"syncing device token with Socialize REST API");
        [self registerDeviceTokenString:deviceToken];
    }  else {
        [self invalidateRegisterDeviceTimer];
    }
}
-(void)invokeAppropriateCallback:(SocializeRequest*)request objectList:(id)objectList errorList:(id)errorList {
    NSMutableArray* array = [self getObjectListArray:objectList];
    SocializeDeviceToken *deviceToken = (SocializeDeviceToken *)[array objectAtIndex:0];
    [Socialize storeDeviceToken:deviceToken.device_token];
    
    SDebugLog(1, @"Successfully registered device with token %@", deviceToken.device_token);
    
    [super invokeAppropriateCallback:request objectList:objectList errorList:errorList];
}
-(void)registerDeviceTokenString:(NSString *)deviceToken {
    [self registerDeviceTokens:[NSArray arrayWithObject:deviceToken]];
}

-(void)startTimerWithBlock:(BKTimerBlock)timerBlock {
    self.registerDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 block:timerBlock repeats:YES];
}

-(void)registerDeviceToken:(NSString *)deviceToken persistent:(BOOL)isPersistent {
    //if it is persistent, we'll create a timer that'll keep trying to persist the key until it reaches success
    deviceToken = [deviceToken uppercaseString];
    if( isPersistent ) {
        BKTimerBlock timerBlock = ^(NSTimeInterval time) {
            [self registerDeviceTokensWithTimer:deviceToken];
        };
        [self startTimerWithBlock:timerBlock];
    } else {
        //execute timerblock directly since we don't need to add it to a timer
        [self registerDeviceTokenString:deviceToken];
    }
}
-(void)registerDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    [self registerDeviceToken:deviceTokenStr persistent:YES];
}
-(Protocol *)ProtocolType
{
    return  @protocol(SocializeDeviceToken);
}

@end
