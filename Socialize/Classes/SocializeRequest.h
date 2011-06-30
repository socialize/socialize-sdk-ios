//
//  SocializeRequest.h
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAConsumer.h"
#import "OAAsynchronousDataFetcher.h"

@protocol SocializeRequestDelegate;

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
    OAAsynchronousDataFetcher   *_dataFetcher;
}

@property (nonatomic, readonly) NSString * userAgentString;
@property(nonatomic,assign) id<SocializeRequestDelegate> delegate;
@property(nonatomic,copy)   NSString                    *url;
@property(nonatomic,copy)   NSString                    *httpMethod;
@property(nonatomic,retain) id                          params;
@property(nonatomic,retain) NSURLConnection             *connection;
@property(nonatomic,retain) NSMutableData               *responseText;
@property(nonatomic,retain) OAToken                     *token;
@property(nonatomic,retain) OAConsumer                  *consumer;
@property(nonatomic,retain) OAMutableURLRequest         *request;
@property(nonatomic,retain) OAAsynchronousDataFetcher   *dataFetcher;

+ (SocializeRequest*)getRequestWithParams:(NSMutableDictionary *) params
                        httpMethod:(NSString *) httpMethod
                          delegate:(id<SocializeRequestDelegate>)delegate
                        requestURL:(NSString *) url;

+ (NSString *)userAgentString;
- (BOOL) loading;

- (void) connect;

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
