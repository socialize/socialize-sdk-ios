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
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAAsynchronousDataFetcher.h"

#import "JSONKit.h"

@interface SocializeAuthenticateService()
-(NSString*)getSocializeId;
-(NSString*)getSocializeToken;
-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest;
-(void)persistUserInfo:(NSDictionary*)dictionary;
@end

@implementation SocializeAuthenticateService

@synthesize provider = _provider;

-(id)init{
    self = [super init];
    if(self != nil){
        _provider = [[SocializeProvider alloc] init];
    }
    return self;
}

-(void)dealloc{
    [_provider release];
    _provider = nil;
    [super dealloc];
}


-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest
{
    NSData* jsonData =  [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            jsonData, @"jsonData",
            nil];
}

#define AUTHENTICATE_METHOD @"authenticate/"

-(void)authenticateWithApiKey:(NSString*)apiKey 
          apiSecret:(NSString*)apiSecret
               udid:(NSString*)udid
            delegate:(id<SocializeAuthenticationDelegate>)delegate
         {
             
    _delegate = delegate;
    NSString* payloadJson = [[NSDictionary dictionaryWithObjectsAndKeys:udid, @"udid", nil] JSONString];
    NSString* jsonParams = [NSString stringWithFormat:@"payload=%@", payloadJson];//[[NSDictionary dictionaryWithObjectsAndKeys:payloadJson, @"payload", nil] JSONString];
             
    NSLog(@"jsonParams %@", jsonParams);
             
    NSMutableDictionary* paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setObject:udid forKey:@"udid"];
    [_provider requestWithMethodName:AUTHENTICATE_METHOD andParams:paramsDict andHttpMethod:@"POST" andDelegate:self];
}

- (void)tokenRequestModifyRequest:(OAMutableURLRequest *)oRequest{
	// Subclass to add custom paramaters and headers
}

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
        if ((userId != nil) && ((id)userId != [NSNull null]))
            [userDefaults setObject:userId forKey:kSOCIALIZE_USERID_KEY];
        
        NSString* username = [dictionary objectForKey:@"username"]; 
        // NSString* userId = [dictionary objectForKey:@"user"]; 
        if ((username != nil) && ((id)username != [NSNull null]))
            [userDefaults setObject:username forKey:kSOCIALIZE_USERNAME_KEY];

        NSString* smallImageUri = [dictionary objectForKey:@"small_image_uri"]; 
        
        if ((smallImageUri != nil) && ((id)smallImageUri != [NSNull null]))
            [userDefaults setObject:smallImageUri forKey:kSOCIALIZE_USERIMAGEURI_KEY];
        
        [userDefaults synchronize];
    }
}

-(NSString*)getSocializeId{
    NSUserDefaults* userPreferences = [NSUserDefaults standardUserDefaults];
    NSString* userJSONObject = [userPreferences valueForKey:kSOCIALIZE_USERID_KEY];
    if (!userJSONObject)
        return @"";
    return userJSONObject;
}

-(NSString*)getSocializeToken{
    OAToken *authToken = [[[OAToken alloc ]initWithUserDefaultsUsingServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX] autorelease];
    if (authToken.key)
        return authToken.key;
    else 
        return nil;
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
   NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:udid, @"udid", 
                             [self getSocializeId],  @"socialize_id", 
                             @"1"/* auth type is for facebook*/ , @"auth_type",
                             thirdPartyAuthToken, @"auth_token",
                             thirdPartyUserId, @"auth_id" , nil] ;
                               
//   NSString* jsonParams = [[NSDictionary dictionaryWithObjectsAndKeys:payloadJson, @"payload", nil] JSONString];
  // NSMutableDictionary* params = [self genereteParamsFromJsonString:jsonParams];
   [_provider requestWithMethodName:AUTHENTICATE_METHOD andParams:dictionary andHttpMethod:@"POST" andDelegate:self];
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

@end