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


@implementation SocializeService

@synthesize delegate = _delegate;

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeObject);
}
-(void) dealloc
{   _provider = nil;
    _objectCreator = nil;
    [super dealloc];
}



-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate:(id) delegate
{
    self = [super init];
    if(self != nil)
    {
        _provider = provider;
        _objectCreator = objectFactory;
        self.delegate = delegate;
    }
    
    return self;
}

//-(id<SocializeObject>)newObject
//{
//    return [self newObjectForProtocol:self.ProtocolType];
//}
//
//-(id<SocializeObject>)newObjectForProtocol:(Protocol *)protocol
//{
//    return [_objectCreator createObjectForProtocol:protocol];
//}

-(void)ExecuteGetRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)requestParameters;
{
    [_provider requestWithMethodName:endPoint andParams:requestParameters andHttpMethod:@"GET" andDelegate:self];
}

-(void)ExecutePostRequestAtEndPoint:(NSString *)endPoint  WithObject:(id)postRequestObject;
{
    NSString * stringRepresentation =  [_objectCreator createStringRepresentationOfObject:postRequestObject]; 
    NSMutableDictionary* params = [self genereteParamsFromJsonString:stringRepresentation];
    [self ExecutePostRequestAtEndPoint:endPoint  WithParams:params];
}

-(void)ExecutePostRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)postRequestParameters;
{
    
    [_provider requestWithMethodName:endPoint andParams:postRequestParameters andHttpMethod:@"POST" andDelegate:self];
}

#pragma mark - Socialize requst delegate

//- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response
//{
//    // TODO:: add implementation notify that call success. 
//}

- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
     [self doDidFailWithError:error];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    //Move the following lines to the base  SocializeService Class, because it's the same for all objects.
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    id objectResponse = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]]; 
    
    
    if([objectResponse conformsToProtocol:@protocol(SocializeObject)])
    {
        [self doDidReceiveSocializeObject:(id<SocializeObject>)objectResponse];
    }
    else if([objectResponse isKindOfClass: [NSArray class]])
    {
        [self doDidReceiveReceiveListOfObjects:(NSArray *)objectResponse];  
    }
    else
    {
        [self doDidFailWithError:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }
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
