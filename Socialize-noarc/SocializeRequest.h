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
    SocializeDictionaryWithListAndErrors,   // Expected response from the service is dictionary of error list and object list
    SocializeAny            //Anything goes...typically for delete
} ExpectedResponseFormat;

/* This defines which SocializeServiceDelegate callback will be invoked to once the request is completed successfully */
typedef enum {
    SocializeRequestOperationTypeInferred,   // The default legacy behavior -- automatically infer callback based on http method and json response
    SocializeRequestOperationTypeCreate,     // Always invoke didCreate:
    SocializeRequestOperationTypeUpdate,     // Always invoke didUpdate:
    SocializeRequestOperationTypeDelete,     // Always invoke didDelete:
    SocializeRequestOperationTypeList,       // Always invoke didFetchElements:
} SocializeRequestOperationType;

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
@property(nonatomic,copy)   NSString                    *resourcePath;
@property(nonatomic,copy)   NSString                    *httpMethod;
@property(nonatomic,retain) id                          params;
@property(nonatomic,retain) NSMutableData               *responseText;
@property(nonatomic,retain) OAToken                     *token;
@property(nonatomic,retain) OAConsumer                  *consumer;
@property(nonatomic,retain) OAMutableURLRequest         *request;
@property(nonatomic,retain) SocializeDataFetcher        *dataFetcher;
@property(nonatomic,assign) SocializeRequestOperationType        operationType;
@property(nonatomic,assign,getter=isSecure) BOOL        secure;
@property(nonatomic,copy) NSString        *baseURL;
@property(nonatomic,copy) NSString        *secureBaseURL;
@property(nonatomic,assign,getter=isRunning) BOOL        running;
@property(nonatomic,assign,getter=isTokenRequest) BOOL        tokenRequest;
@property (nonatomic, assign) Protocol *expectedProtocol;

@property (nonatomic, copy) void (^successBlock)(id objectOrObjects);
@property (nonatomic, copy) void (^failureBlock)(NSError *error);

+ (NSString*)defaultBaseURL;
+ (NSString*)defaultSecureBaseURL;

+ (id)requestWithHttpMethod:(NSString *) httpMethod
               resourcePath:(NSString*)resourcePath
         expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                     params:(id)params;

+ (id)secureRequestWithHttpMethod:(NSString *) httpMethod
                     resourcePath:(NSString*)resourcePath
               expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                           params:(id)params;

- (id)initWithHttpMethod:(NSString *) httpMethod
            resourcePath:(NSString*)resourcePath
      expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                  params:(id)params;

+ (NSString *)userAgentString;
+ (NSString*)consumerKey;
+ (NSString*)consumerSecret;

- (void) connect;
- (void)configureURLRequest;
- (void)cancel;

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
