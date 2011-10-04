//
//  SocializeRequest.m
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeRequest.h"
#import "OAConsumer.h"
#import "SocializeDataFetcher.h"
#import <UIKit/UIKit.h>
#import "NSString+UrlSerialization.h"
#import "OAAsynchronousDataFetcher.h"
#import "OAServiceTicket.h"
#import "SocializeCommonDefinitions.h"
#import "JSONKit.h"
#import <Foundation/NSURLResponse.h>
#import "SocializePrivateDefinitions.h"

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
    +(NSString*)consumerKey;
    +(NSString*)consumerSecret;
@end

@implementation SocializeRequest

@synthesize delegate = _delegate,
url = _url,
httpMethod = _httpMethod,
params = _params,
responseText = _responseText,
token = _token,
consumer = _consumer,
request = _request,
dataFetcher = _dataFetcher,
expectedJSONFormat = _expectedJSONFormat;

+ (NSString *)userAgentString
{   
    NSString   *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSString   *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSString * userAgentStr = [NSString stringWithFormat:@"iOS-%@/%@ SocializeSDK/v1.0; %@_%@; BundleID/%@;",
                               [[UIDevice currentDevice]systemVersion],
                               [[UIDevice currentDevice]model],
                               language,
                               countryCode,
                               [[NSBundle mainBundle] bundleIdentifier]];
    return  userAgentStr;

}

-(NSString *)userAgentString
{
   return [SocializeRequest userAgentString];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// class public


+(NSString*)consumerKey{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kSOCIALIZE_API_KEY_KEY];
}

+(NSString*)consumerSecret{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kSOCIALIZE_API_SECRET_KEY];
}

+ (SocializeRequest *)getRequestWithParams:(id) params
                        expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                                httpMethod:(NSString *) httpMethod
                                  delegate:(id<SocializeRequestDelegate>) delegate
                                requestURL:(NSString *) url 
{
    //We will release object in network responce section. After complete of execution of user delegates;
    SocializeRequest* request = [[SocializeRequest alloc] init]; 
    request.delegate = delegate;
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.responseText = nil;
    request.expectedJSONFormat  = expectedJSONFormat;
    
    
    request.token =  [[[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX ]autorelease];
    request.consumer = [[[OAConsumer alloc] initWithKey:[self consumerKey] secret:[self consumerSecret]] autorelease];
    request.request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:request.url] consumer:request.consumer token:request.token realm:nil signatureProvider:nil] autorelease];
    
    request.dataFetcher = [[[SocializeDataFetcher alloc] initWithRequest:request.request delegate:request
                                                           didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                             didFailSelector:@selector(tokenRequestTicket:didFailWithError:)]autorelease];
    
    NSArray* hosts = [[[NSArray alloc] initWithObjects: @"stage.api.getsocialize.com", @"getsocialize.com", @"stage.getsocialize.com", @"dev.getsocialize.com", nil] autorelease]; 
    request.dataFetcher.trustedHosts = hosts;
       
    
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
-(void) addParameter: (id)parameter withKey: (NSString*) key toCollection: (NSMutableArray*) collection
{
    NSString* value = [[NSString alloc]initWithFormat:@"%@", parameter];
    OARequestParameter* p = [[OARequestParameter alloc] initWithName:key value:value];
    [collection addObject:p];
    [p release];
    [value release];
}

-(NSArray*) formatUrlParams
{
    NSMutableArray* getParams = [[[NSMutableArray alloc] initWithCapacity:[_params count]] autorelease];
    [_params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if([obj isKindOfClass: [NSArray class]])
         {
                for(id item in obj)
                {
                    [self addParameter:item withKey:key toCollection:getParams];
                }
         }else
         {
             [self addParameter:obj withKey:key toCollection:getParams];
         }
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
    if ([self.httpMethod isEqualToString: @"POST"] || [self.httpMethod isEqualToString: @"PUT"]) 
    {
        NSString * stringValue = nil;
        NSMutableArray* params = [NSMutableArray array];
        if([_params respondsToSelector:@selector(objectForKey:)])
            stringValue = (NSString *) [_params objectForKey:@"jsonData"]; // TEMPORARY SOLUTION!!!!

        if(stringValue == nil)   
            stringValue = [_params  JSONString];
        
        [self addParameter:stringValue withKey:@"payload" toCollection: params];
        [self.request setSocializeParameters:params];
    }
    else if([self.httpMethod isEqualToString: @"GET"])
    {
        [self.request setSocializeParameters:[self formatUrlParams]];
    }
    
    [self.request prepare];
    [self.dataFetcher start];
}

/**
 * Free internal structure
 */
- (void)dealloc 
{
    [_dataFetcher cancel];
    
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
#ifdef DEBUG
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    [self produceHTMLOutput:responseBody];
#endif

    NSHTTPURLResponse* response = (NSHTTPURLResponse*)ticket.response;
    if (response.statusCode == 200)
        [self handleResponseData:data];
    else
        [self failWithError:[NSError errorWithDomain:@"Socialize" code:response.statusCode userInfo:nil]];
    
    [self release];
}

-(void)produceHTMLOutput:(NSString*)outputString{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    
    NSError *error;
    BOOL succeed = [outputString writeToFile:[documentsDirectory stringByAppendingPathComponent:@"error.html"]
                              atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!succeed){ // TODO:: add error handling
        // Handle error here
    }
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error{
    [self  failWithError:error];
    [self release];
}

@end
