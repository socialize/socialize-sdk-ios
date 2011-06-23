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
#import "OAAsynchronousDataFetcher.h"
#import "OAConsumer.h"
#import "OAServiceTicket.h"
#import "SocializeCommonDefinitions.h"
#import "JSONKit.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* const kUserAgent = @"Socialize v1.0/iOS";
static const NSTimeInterval kTimeoutInterval = 180.0;
static const int kGeneralErrorCode = 10000;


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
responseText = _responseText,
token = _token,
consumer = _consumer,
request = _request,
dataFetcher = _dataFetcher
;

//////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (SocializeRequest *)getRequestWithParams:(id) params
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
    
    
    request.token =  [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX ];
    request.consumer = [[OAConsumer alloc] initWithKey:kSOCIALIZE_API_KEY secret:kSOCIALIZE_API_SECRET];
    request.request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:request.url] consumer:request.consumer token:request.token realm:nil signatureProvider:nil];
    
    request.dataFetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:request.request delegate:request
                                                           didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                             didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
    
    if ([request.httpMethod isEqualToString:@"GET"])
        request.url = [NSString serializeURL:request.url params:(NSDictionary*)request.params httpMethod:request.httpMethod];
    
    
    
    return request;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/*
 * private helper function: call the delegate function when the request
 *                          fails with error
 */
- (void)failWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [_delegate request:self didFailWithError:error];
    }
}


/**
 * Formulate the NSError
 */
- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
    return [NSError errorWithDomain:@"Socialize" code:code userInfo:errorData];
}

/**
 * parse the response data
 */
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
    return nil;
}


/*
 * private helper function: handle the response data
 */
- (void)handleResponseData:(NSData *)data {
    if ([_delegate respondsToSelector:
         @selector(request:didLoadRawResponse:)]) {
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
    [self.request setHTTPMethod:self.httpMethod];
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString * stringValue = (NSString *) [_params objectForKey:@"jsonData"];
        //NSString * stringValue = [_params  JSONString];
        NSString* jsonParams = [NSString stringWithFormat:@"payload=%@", stringValue];
        NSLog(@"jsonParams  %@", jsonParams);
        [self.request setHTTPBody:[jsonParams dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [self.request prepare];
    [self.dataFetcher start];
}

/**
 * Free internal structure
 */
- (void)dealloc 
{
    [_token release]; _token = nil;
    [_consumer release]; _consumer = nil;
    [_request release]; _request = nil;
    [_dataFetcher release]; _dataFetcher = nil;
    [_responseText release]; _responseText = nil;
    [_url release]; _url = nil;
    [_httpMethod release]; _httpMethod = nil;
    [_params release]; _params = nil;
    [super dealloc];
}


- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSLog(@"responseBody %@", responseBody);
	if (ticket.didSucceed) 
        [self handleResponseData:data];
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error{
    [self  failWithError:error];
}

@end
