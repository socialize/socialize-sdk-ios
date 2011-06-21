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
    return [NSError errorWithDomain:@"SocializeErrDomain" code:code userInfo:errorData];
}

/**
 * parse the response data
 */
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
    
 /*   NSString* responseString = [[[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding]
                                autorelease];
    SBJsonParser *jsonParser = [[SBJsonParser new] autorelease];
    if ([responseString isEqualToString:@"true"]) {
        return [NSDictionary dictionaryWithObject:@"true" forKey:@"result"];
    } else if ([responseString isEqualToString:@"false"]) {
        if (error != nil) {
            *error = [self formError:kGeneralErrorCode
                            userInfo:[NSDictionary
                                      dictionaryWithObject:@"This operation can not be completed"
                                      forKey:@"error_msg"]];
        }
        return nil;
    }
    
    id result = [jsonParser objectWithString:responseString];
    
    if (![result isKindOfClass:[NSArray class]]) {
        if ([result objectForKey:@"error"] != nil) {
            if (error != nil) {
                *error = [self formError:kGeneralErrorCode
                                userInfo:result];
            }
            return nil;
        }
        
        if ([result objectForKey:@"error_code"] != nil) {
            if (error != nil) {
                *error = [self formError:[[result objectForKey:@"error_code"] intValue] userInfo:result];
            }
            return nil;
        }
        
        if ([result objectForKey:@"error_msg"] != nil) {
            if (error != nil) {
                *error = [self formError:kGeneralErrorCode userInfo:result];
            }
        }
        
        if ([result objectForKey:@"error_reason"] != nil) {
            if (error != nil) {
                *error = [self formError:kGeneralErrorCode userInfo:result];
            }
        }
    }
  */
    
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
    if ([self.httpMethod isEqualToString:@"GET"])
        self.url = [NSString serializeURL:_url params:_params httpMethod:self.httpMethod];
    
    OAToken *token =  [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX ];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kSOCIALIZE_API_KEY secret:kSOCIALIZE_API_SECRET];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.url] consumer:consumer token:token realm:nil signatureProvider:nil];
    
    [request setHTTPMethod:self.httpMethod];
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString * stringValue = [_params JSONString];
        NSString* jsonParams = [NSString stringWithFormat:@"payload=%@", stringValue];
        NSLog(@"jsonParams  %@", jsonParams);
        [request setHTTPBody:[jsonParams dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request prepare];
    
    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:request
                                                 delegate:self
                                                 didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                 didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
    [fetcher start];	
}

/**
 * Free internal structure
 */
- (void)dealloc 
{
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
