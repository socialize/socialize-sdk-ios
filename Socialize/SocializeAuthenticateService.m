//
//  SocializeAuthenticateService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeAuthenticateService.h"
#import "SocializeRequest.h"
#import "SocializeProvider.h"
#import "SBJson.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAAsynchronousDataFetcher.h"

#import "JSONKit.h"

@interface SocializeAuthenticateService()
-(NSString*)getSocializeId;
-(NSString*)getSocializeToken;
-(void)persistUserInfo:(NSDictionary*)dictionary;
@end

@implementation SocializeAuthenticateService

-(id)init{
    self = [super init];
    if(self != nil){
        _provider = [[SocializeProvider alloc] init];
    }
    return self;
}

-(void)dealloc{
    [_provider release];
}

//OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" secret:@"b7364905-cdc6-46d3-85ad-06516b128819"];

-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
               udid:(NSString*)udid
            delegate:(id<SocializeAuthenticationDelegate>)delegate
         {
             
    _delegate = delegate;
    
    NSURL *url = [NSURL URLWithString:@"http://www.dev.getsocialize.com/v1/authenticate/"];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:apiKey secret:apiSecret];

    OAMutableURLRequest *req = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:nil realm:nil signatureProvider:nil];
    NSString* jsonString = [NSString stringWithFormat:@"payload={\"udid\":\"%@\"}", udid];

    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req prepare];
     
    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:req
                                                                                           delegate:self
                                                                                  didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                                                    didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
             
    [fetcher start];
}

- (void)tokenRequestModifyRequest:(OAMutableURLRequest *)oRequest
{
	// Subclass to add custom paramaters and headers
}

#define kPROVIDER_NAME @"SOCIALIZE"
#define kPROVIDER_PREFIX @"AUTH"

+(BOOL)isAuthenticated {
    OAToken *authToken = [[[OAToken alloc ]initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX] autorelease];
    if (authToken.key)
        return YES;
    else
        return NO;
}

-(void)persistUserInfo:(NSDictionary*)dictionary{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults){
        NSString* userId = [dictionary objectForKey:@"id"]; 
       // NSString* userId = [dictionary objectForKey:@"user"]; 
        [userDefaults setObject:userId forKey:kSOCIALIZE_USERID_KEY];
        
        NSString* username = [dictionary objectForKey:@"username"]; 
        // NSString* userId = [dictionary objectForKey:@"user"]; 
        [userDefaults setObject:username forKey:kSOCIALIZE_USERNAME_KEY];

        NSString* smallImageUri = [dictionary objectForKey:@"small_image_uri"]; 
        // NSString* userId = [dictionary objectForKey:@"user"]; 
        [userDefaults setObject:smallImageUri forKey:kSOCIALIZE_USERIMAGEURI_KEY];
        
        [userDefaults synchronize];
    }
}

-(NSString*)getSocializeId{
    NSUserDefaults* userPreferences = [NSUserDefaults standardUserDefaults];
    NSString* userJSONObject = [userPreferences valueForKey:kSOCIALIZE_USERID_KEY];
    return userJSONObject;
}

-(NSString*)getSocializeToken{
    OAToken *authToken = [[[OAToken alloc ]initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX] autorelease];
    if (authToken.key)
        return authToken.key;
    else 
        return nil;
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	NSLog(@"tokenRequestTicket Response Body: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	if (ticket.didSucceed) 
	{
        OAToken *requestToken;
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [requestToken storeInUserDefaultsWithServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX];
        
        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
        id jsonObject = [jsonKitDecoder objectWithData:data];
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            [self persistUserInfo:[jsonObject objectForKey:@"user"]];
        }
        
 		[responseBody release];
	}
    else
        [_delegate didNotAuthenticate:nil];
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    [_delegate didNotAuthenticate:error];
    NSLog(@"Socialize Authentication Failed");
}


-(void)authenticateWithApiKey:(NSString*)apiKey 
                            apiSecret:(NSString*)apiSecret 
                                 udid:(NSString*)udid
                  thirdPartyAuthToken:(NSString*)thirdPartyAuthToken
                     thirdPartyUserId:(NSString*)thirdPartyUserId
                       thirdPartyName:(ThirdPartyAuthName)thirdPartyName
                             delegate:(id<SocializeAuthenticationDelegate>)delegate
                           {
                               
       _delegate = delegate;
       
       NSURL *url = [NSURL URLWithString:@"http://www.dev.getsocialize.com/v1/authenticate/"];
       OAConsumer *consumer = [[OAConsumer alloc] initWithKey:apiKey secret:apiSecret];
       
       NSString* jsonString = [NSString stringWithFormat:@"payload={\"udid\":\"%@\",\"socialize_id\":\"%@\",\"auth_type\":\"%@\", \"auth_token\":\"%@\", \"auth_id\":%@}", udid, [self getSocializeId], @"1", thirdPartyAuthToken, thirdPartyUserId];
       OAMutableURLRequest *req = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:nil realm:nil signatureProvider:nil];
       
       [req setHTTPMethod:@"POST"];
       [req setHTTPBody:[(NSString*)jsonString dataUsingEncoding:NSUTF8StringEncoding]];
       [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       [req prepare];
       
       OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:req
                                                                                             delegate:self
                                                                                    didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                                                      didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
       [fetcher start];	
}


/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error{
    [_delegate didNotAuthenticate:error];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on the format of the API response.
 */

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
}


- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data{
    
}

@end