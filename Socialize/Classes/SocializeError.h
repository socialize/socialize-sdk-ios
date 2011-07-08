//
//  SocializeError.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/5/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"

@protocol SocializeError <SocializeObject>
-(NSString*)error;
-(void)setError:(NSString*)errorString;

-(NSString*)payload;
-(void)setPayload:(NSString*)payloadString;

@end

@interface SocializeError : SocializeObject<SocializeError> {
    NSString*       _error;
    NSString*       _payload;
}


@property (nonatomic, retain) NSString* error;
@property (nonatomic, retain) NSString* payload;

@end