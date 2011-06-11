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
#import "SBJson.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* const kUserAgent = @"Socialize";
static NSString* const kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";
static const int kGeneralErrorCode = 10000;

static const NSTimeInterval kTimeoutInterval = 180.0;

@interface SocializeRequest()

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


/**
 * Body append for POST method
 */
- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
    [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 * Generate body for POST method
 */
- (NSMutableData *)generatePostBody {
    NSMutableData *body = [NSMutableData data];
    NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]];
    
    for (id key in [_params keyEnumerator]) {
        
        if (([[_params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[_params valueForKey:key] isKindOfClass:[NSData class]])) {
            
            [dataDictionary setObject:[_params valueForKey:key] forKey:key];
            continue;
            
        }
        
        [self utfAppendBody:body
                       data:[NSString
                             stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                             key]];
        [self utfAppendBody:body data:[_params valueForKey:key]];
        
        [self utfAppendBody:body data:endLine];
    }
    
    if ([dataDictionary count] > 0) {
        for (id key in dataDictionary) {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            if ([dataParam isKindOfClass:[UIImage class]]) {
                NSData* imageData = UIImagePNGRepresentation((UIImage*)dataParam);
                [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"]];
                [body appendData:imageData];
            } else {
                NSAssert([dataParam isKindOfClass:[NSData class]],
                         @"dataParam must be a UIImage or NSData");
                [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:[NSString stringWithString:@"Content-Type: content/unknown\r\n\r\n"]];
                [body appendData:(NSData*)dataParam];
            }
            [self utfAppendBody:body data:endLine];
            
        }
    }
    
    return body;
}

/**
 * Formulate the NSError
 */
- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
    return [NSError errorWithDomain:@"facebookErrDomain" code:code userInfo:errorData];
    
}

/**
 * parse the response data
 */
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
    
    NSString* responseString = [[[NSString alloc] initWithData:data
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
    
    return result;
    
}

/*
 * private helper function: call the delegate function when the request fail with Error
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
    if ([_delegate respondsToSelector:@selector(request:didLoadRawResponse:)]) {
        [_delegate request:self didLoadRawResponse:data];
    }
    
    if ([_delegate respondsToSelector:@selector(request:didLoad:)] ||
        [_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        NSError* error = nil;
        id result = [self parseJsonResponse:data error:&error];
        if (error) {
            [self failWithError:error];
        } else if ([_delegate respondsToSelector:@selector(request:didLoad:)]) {
            [_delegate request:self didLoad:(result == nil ? data : result)];
        }
        
    }
    
}



//////////////////////////////////////////////////////////////////////////////////////////////////
// public

/**
 * @return boolean - whether this request is processing
 */
- (BOOL)loading {
    return !!_connection;
}

/**
 * make the Facebook request
 */
- (void)connect {
    
    if ([_delegate respondsToSelector:@selector(requestLoading:)]) {
        [_delegate requestLoading:self];
    }
    
    NSString* url = [NSString serializeURL:_url params:_params httpMethod:_httpMethod];
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:kTimeoutInterval];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    [request setHTTPMethod:self.httpMethod];
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString* contentType = [NSString
                                 stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:[self generatePostBody]];
    }
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

/**
 * Free internal structure
 */
- (void)dealloc {
    [_connection cancel];
    [_connection release];
    [_responseText release];
    [_url release];
    [_httpMethod release];
    [_params release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseText = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if ([_delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
        [_delegate request:self didReceiveResponse:httpResponse];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseText appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self handleResponseData:_responseText];
    
    [_responseText release];
    _responseText = nil;
    [_connection release];
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self failWithError:error];
    
    [_responseText release];
    _responseText = nil;
    [_connection release];
    _connection = nil;
}


@end
