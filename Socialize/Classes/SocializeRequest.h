//
//  SocializeRequest.h
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
    SocializeRequestMethodGET = 0,
    SocializeRequestMethodPUT = 1,
    SocializeRequestMethodPOST = 2
    
} SocializeRequestMethod;

@interface SocializeRequest : NSObject 
{
    NSString * requestID;
    NSString * endPoint;
    SocializeRequestMethod * method;
    NSObject * Object;
    BOOL isSecure;
}

@property (readonly) NSString * requestID;
@property (nonatomic, copy) NSString * endPoint;
@property (nonatomic) SocializeRequestMethod * method;
@property (nonatomic, retain ) NSObject * Object;
@property (nonatomic) BOOL isSecure;

@end
