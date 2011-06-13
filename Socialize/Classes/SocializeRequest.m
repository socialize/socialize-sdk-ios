//
//  SocializeRequest.m
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeRequest.h"
#import <UIKit/UIKit.h>
#import "NSString+UrlSerialization.h"
#import "NSMutableData+PostBody.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* const kUserAgent = @"Socialize";
static const NSTimeInterval kTimeoutInterval = 180.0;

@interface SocializeRequest()
    - (void)failWithError:(NSError *)error;
    - (void)handleResponseData:(NSData *)data;
@end

@implementation SocializeRequest

@synthesize delegate = _delegate,
url = _url,
httpMethod = _httpMethod,
params = _params,
connection = _connection,
responseText = _responseText;

//////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (SocializeRequest *)getRequestWithParams:(NSMutableDictionary *) params
                         httpMethod:(NSString *) httpMethod
                           delegate:(id<SocializeRequestDelegate>) delegate
                         requestURL:(NSString *) url 
{
    SocializeRequest* request = [[[SocializeRequest alloc] init] autorelease];
    request.delegate = delegate;
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.connection = nil;
    request.responseText = nil;
    
    return request;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/*
 * private helper function: call the delegate function when the request fail with Error
 */
- (void)failWithError:(NSError *)error 
{
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [_delegate request:self didFailWithError:error];
    }
}

/*
 * private helper function: handle the response data
 */
- (void)handleResponseData:(NSData *)data 
{
    if ([_delegate respondsToSelector:@selector(request:didLoadRawResponse:)]) {
        [_delegate request:self didLoadRawResponse:data];
    }
}



//////////////////////////////////////////////////////////////////////////////////////////////////
// public

/**
 * @return boolean - whether this request is processing
 */
- (BOOL)loading 
{
    return !!_connection;
}

/**
 * make the Socialize request
 */
- (void)connect
{   
    NSString* url = [NSString serializeURL:_url params:_params httpMethod:_httpMethod];
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:kTimeoutInterval];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    [request setHTTPMethod:self.httpMethod];
    if ([self.httpMethod isEqualToString: @"POST"]) 
    {
        NSString* contentType = [NSString
                                 stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:[NSMutableData generatePostBodyWithParams:_params]];
    }
    
    if ([_delegate respondsToSelector:@selector(requestLoading:)]) 
    {
        self.connection = [_delegate requestLoading:request];
        [_connection start];
    }
    else
    {
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];   
    }
}

/**
 * Free internal structure
 */
- (void)dealloc 
{
    [_connection cancel];
    [_connection release]; _connection = nil;
    [_responseText release]; _responseText = nil;
    [_url release]; _url = nil;
    [_httpMethod release]; _httpMethod = nil;
    [_params release]; _params = nil;
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    _responseText = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if ([_delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
        [_delegate request:self didReceiveResponse:httpResponse];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [_responseText appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self handleResponseData:_responseText];
    
    [_responseText release];
    _responseText = nil;
    [_connection release];
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [self failWithError:error];
    
    [_responseText release];
    _responseText = nil;
    [_connection release];
    _connection = nil;
}

@end
