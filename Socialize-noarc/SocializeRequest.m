//
//  SocializeRequest.m
//  SocializeSDK
//
//  Created by William Johnson on 6/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeRequest.h"
#import <OAuthConsumer/OAuthConsumer.h>
#import "SocializeDataFetcher.h"
#import <UIKit/UIKit.h>
#import "NSString+UrlSerialization.h"
#import "SocializeCommonDefinitions.h"
#import <SZJSONKit/JSONKit.h>
#import <Foundation/NSURLResponse.h>
#import "SocializePrivateDefinitions.h"
#import "SocializeConfiguration.h"
#import "socialize_globals.h"

@interface OAMutableURLRequest ()
- (NSString *)_signatureBaseString;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* const kUserAgent = @"Socialize v" SOCIALIZE_VERSION_STRING @"/iOS";
static const NSTimeInterval kTimeoutInterval = 180.0;
static const int kGeneralErrorCode = 10000;


@interface SocializeRequest()
@property (nonatomic, assign) BOOL cancelled;

    -(void)failWithError:(NSError *)error;
    -(void)handleResponseData:(NSData *)data;
    -(void)produceHTMLOutput:(NSString*)outputString;
    -(NSArray*) formatUrlParams;
    +(NSString*)consumerKey;
    +(NSString*)consumerSecret;
- (void)startRunningIfNecessary;

@end

@implementation SocializeRequest

@synthesize delegate = _delegate,
resourcePath = _resource,
httpMethod = _httpMethod,
params = _params,
responseText = _responseText,
token = _token,
consumer = _consumer,
request = _request,
dataFetcher = _dataFetcher,
expectedJSONFormat = _expectedJSONFormat,
operationType = _requestType,
secure = _secure,
baseURL = _baseURL,
secureBaseURL = _secureBaseURL,
running = _running,
tokenRequest = _tokenRequest;
@synthesize cancelled = cancelled_;
@synthesize expectedProtocol = expectedProtocol_;
@synthesize successBlock = successBlock_;
@synthesize failureBlock = failureBlock_;

+ (NSString *)userAgentString
{   
    NSString   *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSString   *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSString * userAgentStr = [NSString stringWithFormat:@"iOS-%@/%@ SocializeSDK/v%@; %@_%@; BundleID/%@;",
                               [[UIDevice currentDevice]systemVersion],
                               [[UIDevice currentDevice]model],
                               SOCIALIZE_VERSION_STRING,
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

+ (NSString*)defaultBaseURL {
    return [[SocializeConfiguration sharedConfiguration] restserverBaseURL];
}

+ (NSString*)defaultSecureBaseURL {
    return [[SocializeConfiguration sharedConfiguration] secureRestserverBaseURL];
}

+ (NSString*)consumerKey{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kSocializeConsumerKey];
}

+ (NSString*)consumerSecret{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kSocializeConsumerSecret];
}

- (NSString*)baseURL {
    if (_baseURL == nil) {
        _baseURL = [[[self class] defaultBaseURL] copy];
    }
    
    return _baseURL;
}

- (NSString*)secureBaseURL {
    if (_secureBaseURL == nil) {
        _secureBaseURL = [[[self class] defaultSecureBaseURL] copy];
    }
    
    return _secureBaseURL;
}


- (NSString*)fullURL:(NSString*)socializeResource {
    NSString *base = [self baseURL];
    return [base stringByAppendingString:socializeResource];
}

- (NSString*)fullSecureURL:(NSString*)socializeResource {
    NSString *base = [self secureBaseURL];
    return [base stringByAppendingString:socializeResource];
}

+ (id)requestWithHttpMethod:(NSString *) httpMethod
               resourcePath:(NSString*)resourcePath
         expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                     params:(id)params
{
    SocializeRequest *request = [[[SocializeRequest alloc]
                                  initWithHttpMethod:httpMethod
                                  resourcePath:resourcePath
                                  expectedJSONFormat:expectedJSONFormat
                                  params:params]
                                 autorelease];
    return request;
}

+ (id)secureRequestWithHttpMethod:(NSString *) httpMethod
               resourcePath:(NSString*)resourcePath
         expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                     params:(id)params
{
    SocializeRequest *request = [self requestWithHttpMethod:httpMethod resourcePath:resourcePath expectedJSONFormat:expectedJSONFormat params:params];
    request.secure = YES;
    return request;
}

- (BOOL)isEqual:(SocializeRequest*)other {
    if (![other isKindOfClass:[self class]])
        return NO;
    
    BOOL same =  
        [other.userAgentString isEqualToString:self.userAgentString]
    &&  [other.resourcePath isEqualToString:self.resourcePath]
    &&  [other.httpMethod isEqualToString:self.httpMethod]
    &&  ([other.params isEqual:self.params] || (other.params == nil && self.params == nil))
    &&  [other.baseURL isEqualToString:self.baseURL]
    &&  [other.secureBaseURL isEqualToString:self.secureBaseURL]
    &&  other.operationType == self.operationType
    &&  other.secure == self.secure
    &&  other.expectedJSONFormat == self.expectedJSONFormat;
    
    return same;
}

/*
+ (id)requestWithHttpMethod:(NSString *) httpMethod
               resourcePath:(NSString*)resourcePath
         expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                     object:(id<SocializeObject>)object
              objectFactory:(SocializeObjectFactory*)objectFactory
{
    NSString *json =  [objectFactory createStringRepresentationOfObject:object]; 
    NSMutableDictionary *params = [self generateParamsFromJsonString:json];

    SocializeRequest *request = [[[SocializeRequest alloc]
                                  initWithHttpMethod:httpMethod
                                  resourcePath:resourcePath
                                  expectedJSONFormat:expectedJSONFormat
                                  params:params]
                                 autorelease];
    return request;
}
 */

- (id)initWithHttpMethod:(NSString *) httpMethod
            resourcePath:(NSString*)resourcePath
      expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                  params:(id)params;
{
    if ((self = [super init])) {
        self.resourcePath = resourcePath;
        self.httpMethod = httpMethod;
        self.params = params;
        self.responseText = nil;
        self.expectedJSONFormat  = expectedJSONFormat;
        self.operationType = SocializeRequestOperationTypeInferred;
    }   
    
    return self;
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
                    [getParams addObject:[OARequestParameter requestParameterWithName:key value:[item description]]];
                }
         }else
         {
             [getParams addObject:[OARequestParameter requestParameterWithName:key value:[obj description]]];
         }
     }
    ];
    
    return getParams;
}

- (void)configureURLRequest {
    if (_secure) {
        [self.request setURL:[NSURL URLWithString:[self fullSecureURL:self.resourcePath]]];
    } else {
        [self.request setURL:[NSURL URLWithString:[self fullURL:self.resourcePath]]];
    }
    
    [self.request setHTTPMethod:self.httpMethod];
    [self.request addValue:[SocializeRequest userAgentString] forHTTPHeaderField:@"User-Agent"];
    if ([self.httpMethod isEqualToString: @"POST"] || [self.httpMethod isEqualToString: @"PUT"]) 
    {
        NSString * stringValue = nil;
        NSMutableArray* params = [NSMutableArray array];
        if([self.params respondsToSelector:@selector(objectForKey:)])
            stringValue = (NSString *) [self.params objectForKey:@"jsonData"]; // TEMPORARY SOLUTION!!!!
        
        if(stringValue == nil)
            stringValue = [self.params  JSONString];
        
        [params addObject:[OARequestParameter requestParameterWithName:@"payload" value:stringValue]];          
        [self.request setOAParameters:params];
    }   
    else if([self.httpMethod isEqualToString: @"GET"] || [self.httpMethod isEqualToString:@"DELETE"])
    {
        [self.request setOAParameters:[self formatUrlParams]];
    }
    
    [self.request prepare];
}

- (OAToken*)token {
    if (_token == nil) {
        if (!self.isTokenRequest) {
            _token =  [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX];
        }
    }
    return _token;
}

- (OAMutableURLRequest*)request {
    if (_request == nil) {
        OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:[SocializeRequest consumerKey] secret:[SocializeRequest consumerSecret]] autorelease];

        _request = [[OAMutableURLRequest alloc] initWithURL:nil consumer:consumer token:self.token realm:nil signatureProvider:nil];
        [_request setTimeoutInterval:30];
    }
    
    return _request;
}

- (SocializeDataFetcher*)dataFetcher {
    if (_dataFetcher == nil) {
        _dataFetcher = [[SocializeDataFetcher alloc] initWithRequest:self.request delegate:self
                                                   didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                     didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
        _dataFetcher.trustedHosts = [NSArray arrayWithObjects:@"stage.api.getsocialize.com", @"api.getsocialize.com", @"dev.getsocialize.com", nil];
    }
    
    return _dataFetcher;
}

/**
 * make the Socialize request
 */
- (void)connect
{   
    if (_running)
        return;

    [self startRunningIfNecessary];
    
    // Request preparation can take a long time for large data in POST requests.
    // This is because the request signing includes the urlencoded POST body
    // Because of this, we prepare the request in the background, then begin 
    // execution on the main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.cancelled) {
            return;
        }
        
        [self configureURLRequest];
        
        // Begin request on the main thread, because NSURLConnection calls its delegate on the
        // thread it was started from
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.cancelled) {
                return;
            }
            NSString *body = [[[NSString alloc] initWithData:[self.request HTTPBody] encoding:NSASCIIStringEncoding] autorelease];
            NSString *urlString = [[self.request URL] absoluteString];
            SDebugLog(2, @"----- Sending Request -----");
            SDebugLog(2, @"URL: %@", urlString);
            SDebugLog(2, @"Headers: %@", [[self request] allHTTPHeaderFields]);
            SDebugLog(2, @"OAuth key: %@, OAuth secret: %@", self.token.key, self.token.secret);
            SDebugLog(2, @"Consumer key: %@, Consumer secret: %@", [SocializeRequest consumerKey], [SocializeRequest consumerSecret]);
            SDebugLog(2, @"Signature Base String: %@", [[self request] _signatureBaseString]);
            SDebugLog(2, @"Body: %@", body);
            SDebugLog(2, @"Params: %@", _params);
            SDebugLog(2, @"----- End Request ---------");

            [self.dataFetcher start];
        });
    });
    
}

/**
 * Free internal structure
 */
- (void)dealloc 
{
    // TODO cancelling the datafetcher in dealloc does not make sense (circular reference)
    [_dataFetcher cancel];
    
    self.successBlock = nil;
    self.failureBlock = nil;
    [_token release]; _token = nil;
    [_consumer release]; _consumer = nil;
    [_request release]; _request = nil;
    [_dataFetcher release]; _dataFetcher = nil;
    [_responseText release]; _responseText = nil;
    [_resource release]; _resource = nil;
    [_httpMethod release]; _httpMethod = nil;
    [_params release]; _params = nil;
    [super dealloc];
}

- (void)cancel {
    self.cancelled = YES;
    [_dataFetcher cancel];
}

- (void)scheduleRelease {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self release];
    });
}

- (void)startRunningIfNecessary {
    if (!_running) {
        _running = YES;
        [self retain];
    }
}

- (void)stopRunningIfNecessary {
    if (_running) {
        _running = NO;
        [self scheduleRelease];
    }
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    [self stopRunningIfNecessary];
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding];
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)ticket.response;
    NSURLRequest *request = ticket.request;
    NSString *urlString = [[request URL] absoluteString];

#ifdef DEBUG
    [self produceHTMLOutput:responseBody];
#endif
    
    SDebugLog(2, @"----- Received Response -----");
    SDebugLog(2, @"Method: %@", [request HTTPMethod]);
    SDebugLog(2, @"URL: %@", urlString);
    SDebugLog(2, @"Code: %d", [response statusCode]);
    SDebugLog(2, @"Headers: %@", [response allHeaderFields]);
    SDebugLog(2, @"Body: %@", responseBody);
    SDebugLog(2, @"----- End Response ----------");

    if (response.statusCode == 200) {
        [self handleResponseData:data];
    } else {
        [self failWithError:[NSError socializeServerReturnedHTTPErrorErrorWithResponse:response responseBody:responseBody]];
    }
    [responseBody release];
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
    [self stopRunningIfNecessary];
    
    [self  failWithError:error];
}

@end
