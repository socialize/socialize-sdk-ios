//
//  SocializeError.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/5/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"

/**Protocol for socialize error representation.*/
@protocol SocializeError <SocializeObject>
/**Get error description.*/
-(NSString*)error;

/**
 Set error description.
 @param errorString Error description.
 */
-(void)setError:(NSString*)errorString;

/**Get request payload.*/
-(NSString*)payload;
/**Set request payload.
 @param payloadString Request payload.
 */
-(void)setPayload:(NSString*)payloadString;

@end

/**Private implementation of <SocializeError> protocol.*/
@interface SocializeError : SocializeObject<SocializeError> {
    NSString*       _error;
    NSString*       _payload;
}

/**Error description*/
@property (nonatomic, copy) NSString* error;
/**Request description*/
@property (nonatomic, copy) NSString* payload;

@end
