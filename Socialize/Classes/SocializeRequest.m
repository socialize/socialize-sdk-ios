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
-(void)failWithError:(NSError *)error;
-(void)handleResponseData:(NSData *)data;
-(void)produceHTMLOutput:(NSString*)outputString;
-(NSArray*) formatUrlParams;
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

+ (NSString *)userAgentString
{
    NSString * userAgentStr = [NSString stringWithFormat:@"iOS-%@/%@ SocializeSDK/v1.0",[[UIDevice currentDevice]       
                                                                                         model],
                               [[UIDevice currentDevice]systemVersion]];
    return  userAgentStr;

}

-(NSString *)userAgentString
{
   return [SocializeRequest userAgentString];
}

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
       
    DLog(@"Request.url  %@",request.url);
    
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

-(NSArray*) formatUrlParams
{
    NSMutableArray* getParams = [[[NSMutableArray alloc] initWithCapacity:[_params count]] autorelease];
    [_params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         OARequestParameter* p = [[OARequestParameter alloc] initWithName:key value:obj];
         [getParams addObject:p];
         [p release];
     }
    ];
    
    return getParams;
}

/**
 * make the Socialize request
 */
- (void)connect
{   
    [self.request setHTTPMethod:self.httpMethod];
    [self.request addValue:[self userAgentString] forHTTPHeaderField:@"User-Agent"];
    if ([self.httpMethod isEqualToString: @"POST"]) 
    {
        NSString * stringValue = nil;
        if([_params respondsToSelector:@selector(objectForKey:)])
            stringValue = (NSString *) [_params objectForKey:@"jsonData"]; // TEMPORARY SOLUTION!!!!

        if(stringValue == nil)   
            stringValue = [_params  JSONString];
        
        NSString* jsonParams = [NSString stringWithFormat:@"payload=%@", stringValue];
        DLog(@"jsonParams  %@", jsonParams);
        [self.request setHTTPBody:[jsonParams dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if([self.httpMethod isEqualToString: @"GET"])
    {
        [self.request setParameters:[self formatUrlParams]];
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
    DLog(@"responseBody %@", responseBody);
#ifdef DEBUG
    [self produceHTMLOutput:responseBody];
#endif
    if (ticket.response.statusCode == 200)
        [self handleResponseData:data];
    else
        [self failWithError:[NSError errorWithDomain:@"SocializeSDK" code:ticket.response.statusCode userInfo:nil]];

}

-(void)produceHTMLOutput:(NSString*)outputString{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    
    NSError *error;
    BOOL succeed = [outputString writeToFile:[documentsDirectory stringByAppendingPathComponent:@"error.html"]
                              atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!succeed){
        // Handle error here
    }
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error{
    [self  failWithError:error];
}

@end
