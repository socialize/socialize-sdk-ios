/*
 * SocializeService.m
 * SocializeSDK
 *
 * Created on 6/17/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SocializeService.h"
#import "JSONKit.h"
#import "SocializeError.h"


@interface SocializeService()
-(void)invokeAppropriateCallback:(SocializeRequest*)request objectList:(id)objectList errorList:(id)errorList;
-(void) dispatch:(SocializeRequest *)request didLoadRawResponse:(NSData *)data;
@end



@implementation SocializeService

@synthesize delegate = _delegate, provider = _provider; 

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeObject);
}
-(void) dealloc
{   
    self.provider = nil;
    _objectCreator = nil;
    self.delegate = nil;
    [super dealloc];
}



-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate:(id<SocializeServiceDelegate>) delegate
{
    self = [super init];
    if(self != nil)
    {
        self.provider = provider;
        _objectCreator = objectFactory;
        self.delegate = delegate;
    }
    
    return self;
}

-(void)ExecuteGetRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)requestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat
{
    [_delegate retain];// Take ownership
    [_provider requestWithMethodName:endPoint andParams:requestParameters   expectedJSONFormat:expectedFormat andHttpMethod:@"GET" andDelegate:self];
}

-(void)ExecutePostRequestAtEndPoint:(NSString *)endPoint  WithObject:(id)postRequestObject expectedResponseFormat:(ExpectedResponseFormat)expectedFormat
{
    NSString * stringRepresentation =  [_objectCreator createStringRepresentationOfObject:postRequestObject]; 
    NSMutableDictionary* params = [self genereteParamsFromJsonString:stringRepresentation];
    [self ExecutePostRequestAtEndPoint:endPoint WithParams:params expectedResponseFormat:expectedFormat];
}

-(void)ExecutePostRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)postRequestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat 
{
    [_delegate retain];// Take ownership
    [_provider requestWithMethodName:endPoint andParams:postRequestParameters expectedJSONFormat:expectedFormat andHttpMethod:@"POST" andDelegate:self];
}

-(void)ExecuteSecurePostRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)postRequestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat 
{
    [_delegate retain];// Take ownership
    [_provider secureRequestWithMethodName:endPoint andParams:postRequestParameters expectedJSONFormat:expectedFormat andHttpMethod:@"POST" andDelegate:self];
}

-(void)ExecuteDeleteRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)deleteRequestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat
{
    [_delegate retain];// Take ownership
    [_provider requestWithMethodName:endPoint andParams:deleteRequestParameters  expectedJSONFormat:SocializeAny andHttpMethod:@"DELETE" andDelegate:self];
}

#pragma mark - Socialize requst delegate


- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error {
     //[self doDidFailWithError:error];
    if([self.delegate respondsToSelector:@selector(service:didFail:)])
        [self.delegate service:self didFail:error];    
    
    [self freeDelegate];
}

-(void)invokeAppropriateCallback:(SocializeRequest*)request objectList:(id)objectList errorList:(id)errorList {

    NSMutableArray* array = nil;
    NSMutableArray* errorArray = nil;
    
    if ([objectList isKindOfClass:[NSArray class]])
        array = objectList;
    else if (objectList != nil){
        array = [NSMutableArray array];
        [array addObject:objectList];
    }
    else {
        array = nil;
        errorArray = nil;
    }
    
    if (![errorList count])
        errorArray = nil;
    else
        errorArray = errorList;

    if ([request.httpMethod isEqualToString:@"POST"]){
        if ([array count])
            if([self.delegate respondsToSelector:@selector(service:didCreate:)])
                [self.delegate service:self didCreate:[array objectAtIndex:0]];
        else
            if([self.delegate respondsToSelector:@selector(service:didCreate:)])
                [self.delegate service:self didCreate:nil];
    }
    else if ([request.httpMethod isEqualToString:@"GET"] && [self.delegate respondsToSelector:@selector(service:didFetchElements:)])
        [self.delegate service:self didFetchElements:array];
    else if ([request.httpMethod isEqualToString:@"DELETE"] && [self.delegate respondsToSelector:@selector(service:didDelete:)])
        [self.delegate service:self didDelete:nil];
    else if ([request.httpMethod isEqualToString:@"PUT"] && [self.delegate respondsToSelector:@selector(service:didUpdate:)])
        [self.delegate service:self didUpdate:objectList];
}

-(void) dispatch:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    //Move the following lines to the base  SocializeService Class, because it's the same for all objects.
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if(request.expectedJSONFormat == SocializeAny)
        [self invokeAppropriateCallback:request objectList:nil errorList:nil];
    
    else if(request.expectedJSONFormat == SocializeDictionaryWIthListAndErrors){
        
        // if it is the response form {errors:"",items:""}
        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
        id jsonObject = [jsonKitDecoder objectWithData:data];
        if (![jsonObject isKindOfClass:[NSDictionary class]])
        {
            // the return object was not what was supposed to be, soo erroring out.
            if([self.delegate respondsToSelector:@selector(service:didFail:)])
                [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
            return;
        }
        
        NSString* errors = [jsonObject objectForKey:@"errors"];
        NSString* items = [jsonObject objectForKey:@"items"];
        
        if (!errors || !items){
            // we should atleast have elements for erors and items in them.
            if([self.delegate respondsToSelector:@selector(service:didFail:)])
                [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
            return;
        }
        
        id objectResponse = [_objectCreator createObjectFromString:items forProtocol:[self ProtocolType]]; 
        id errorResponses = [_objectCreator createObjectFromString:errors forProtocol:@protocol(SocializeError)]; 
        
        if ([errorResponses isKindOfClass: [NSArray class]]){
            if ([errorResponses count]){

                for (SocializeError *errorResp in errorResponses) {
                    NSLog(@"Error: %@", errorResp.error );
                    if([self.delegate respondsToSelector:@selector(service:didFail:)])  {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorResp.error forKey:NSLocalizedDescriptionKey];
                        [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:userInfo]];
                    }
                }
                return;
            }
        }
        
        if([objectResponse isKindOfClass: [NSArray class]]){ 
            if ([objectResponse count]){
                if ([[objectResponse objectAtIndex:0] conformsToProtocol:[self ProtocolType]])
                    [self invokeAppropriateCallback:request objectList:objectResponse errorList:errorResponses];
                else 
                    if([self.delegate respondsToSelector:@selector(service:didFail:)])
                        [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
            }
            else
                [self invokeAppropriateCallback:request objectList:objectResponse errorList:errorResponses];
        }
        else
            if([self.delegate respondsToSelector:@selector(service:didFail:)])
                [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }
    else if (request.expectedJSONFormat == SocializeDictionary){
        id objectResponse = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]]; 
        if ([objectResponse conformsToProtocol:[self ProtocolType]])
            [self invokeAppropriateCallback:request objectList:objectResponse errorList:nil];
        else
            if([self.delegate respondsToSelector:@selector(service:didFail:)])
                [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }
    else if (request.expectedJSONFormat == SocializeList){
        //  NSString* items = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]];
        id objectResponse = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]]; 
        
        if([objectResponse isKindOfClass: [NSArray class]]){ 
            if ([objectResponse count]){
                if ([[objectResponse objectAtIndex:0] conformsToProtocol:[self ProtocolType]])
                    [self invokeAppropriateCallback:request objectList:objectResponse errorList:nil];
                else
                    if([self.delegate respondsToSelector:@selector(service:didFail:)])
                        [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
            }
            else
                if([self.delegate respondsToSelector:@selector(service:didFail:)])
                    [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
        }
        else
            if([self.delegate respondsToSelector:@selector(service:didFail:)])
                [self.delegate service:self didFail:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }
}

-(void)freeDelegate
{
    [_delegate release];//Release ownership 
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    [self dispatch:request didLoadRawResponse:data];
    [self freeDelegate];
}

-(void)doDidReceiveSocializeObject:(id<SocializeObject>)objectResponse
{}

-(void)doDidReceiveReceiveListOfObjects:(NSArray *)objectResponse
{}

-(void)doDidFailWithError:(NSError *)error
{}


-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonData
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            jsonData, @"jsonData",
            nil];
}


@end
