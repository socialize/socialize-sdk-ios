//
//  SocializeRequest.h
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
    SocializeDictionary,   //Expected response from the service is dictionary
    SocializeList,         //Expected response form the service is a list
    SocializeDictionaryWIthListAndErrors,   // Expected response from the service is dictionary of error list and object list
    SocializeAny            //Anything goes...typically for delete
} ExpectedResponseFormat;


@protocol SocializeRequestDelegate;
@class OAServiceTicket;
@class OAToken;
@class OAConsumer;
@class OAMutableURLRequest;
@class SocializeDataFetcher;

@interface SocializeRequest : NSObject 
{

@private
    id<SocializeRequestDelegate> _delegate;
    NSString*                   _url;
    NSString*                   _httpMethod;
    id                          _params;
    NSMutableData*              _responseText;    
    
    OAToken                     *_token;
    OAConsumer                  *_consumer;
    OAMutableURLRequest         *_request;
    SocializeDataFetcher        *_dataFetcher;
    ExpectedResponseFormat      _expectedJSONFormat;// what the SDK is expecting from the API
}

@property (nonatomic, readonly) NSString * userAgentString;
@property(nonatomic,assign) id<SocializeRequestDelegate> delegate;
@property(nonatomic,assign) ExpectedResponseFormat      expectedJSONFormat;
@property(nonatomic,copy)   NSString                    *url;
@property(nonatomic,copy)   NSString                    *httpMethod;
@property(nonatomic,retain) id                          params;
@property(nonatomic,retain) NSMutableData               *responseText;
@property(nonatomic,retain) OAToken                     *token;
@property(nonatomic,retain) OAConsumer                  *consumer;
@property(nonatomic,retain) OAMutableURLRequest         *request;
@property(nonatomic,retain) SocializeDataFetcher        *dataFetcher;

+ (SocializeRequest*)getRequestWithParams:(NSMutableDictionary *) params
                       expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                        httpMethod:(NSString *) httpMethod
                          delegate:(id<SocializeRequestDelegate>)delegate
                        requestURL:(NSString *) url;

+ (NSString *)userAgentString;

- (void) connect;

@end

@interface SocializeRequest(ResponseHandlers)
    - (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
    - (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
@end
///////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *Your application should implement this delegate
 */
@protocol SocializeRequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server. In this method your application should create and return connection instance. 
 * Implement this method only if you need implement custom behaviour of connection instance.
 */
- (id)requestLoading:(NSMutableURLRequest *)request;

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error;

/**
 * Called when a request returns and its response has been parsed into an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(SocializeRequest *)request didLoad:(id)result;

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data;

@end
