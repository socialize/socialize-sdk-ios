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
-(void) dispatch:(SocializeRequest *)request didLoadRawResponse:(NSData *)data;
@end



@implementation SocializeService

@synthesize delegate = _delegate;
@synthesize outstandingRequests = outstandingRequests_;

-(Protocol *)ProtocolType
{
    return  @protocol(SocializeObject);
}
-(void) dealloc
{   
    _objectCreator = nil;
    self.delegate = nil;
    
    for (SocializeRequest *request in outstandingRequests_) {
        [request setDelegate:nil];
        [request cancel];
    }
    self.outstandingRequests = nil;
    [super dealloc];
}



-(id) initWithObjectFactory: (SocializeObjectFactory*) objectFactory delegate:(id<SocializeServiceDelegate>) delegate
{
    self = [super init];
    if(self != nil)
    {
        _objectCreator = objectFactory;
        self.delegate = delegate;
    }
    
    return self;
}

- (NSMutableSet*)outstandingRequests {
    if (outstandingRequests_ == nil) {
        outstandingRequests_ = [[NSMutableSet alloc] init];
    }
    
    return outstandingRequests_;
}

- (void)executeRequest:(SocializeRequest*)request {
    [self retainDelegate];
    [self.outstandingRequests addObject:request];
    request.delegate = self;
    [request connect];
}

- (void)removeRequest:(SocializeRequest*)request {
    if ([self.outstandingRequests containsObject:request]) {
        [self.outstandingRequests removeObject:request];
    }    
}

#pragma mark - Socialize request delegate
- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error {
     //[self doDidFailWithError:error];
    [self removeRequest:request];
    
    if([self.delegate respondsToSelector:@selector(service:didFail:)])
        [self.delegate service:self didFail:error];    
    
    [self freeDelegate];
}

-(NSMutableArray *)getObjectListArray:(id)objectList {
    NSMutableArray* array = nil;
    if ([objectList isKindOfClass:[NSArray class]])
        array = objectList;
    else if (objectList != nil){
        array = [NSMutableArray array];
        [array addObject:objectList];
    }
    else {
        array = nil;
    }    
    return array;
}
-(void)invokeAppropriateCallback:(SocializeRequest*)request objectList:(id)objectList errorList:(id)errorList {

    NSMutableArray* array = [self getObjectListArray:objectList];
    
    if (request.operationType == SocializeRequestOperationTypeInferred) {
    
        if ([request.httpMethod isEqualToString:@"POST"]){
            if ([array count] > 1) {
                if([self.delegate respondsToSelector:@selector(service:didCreate:)]) {
                    [self.delegate service:self didCreate:array];
                }
            } else if ([array count] == 1) {
                if([self.delegate respondsToSelector:@selector(service:didCreate:)]) {
                    [self.delegate service:self didCreate:[array objectAtIndex:0]];
                }
            } else {
                if([self.delegate respondsToSelector:@selector(service:didCreate:)]) {
                    [self.delegate service:self didCreate:nil];
                }
            }
        }
        else if ([request.httpMethod isEqualToString:@"GET"] && [self.delegate respondsToSelector:@selector(service:didFetchElements:)])
            [self.delegate service:self didFetchElements:array];
        else if ([request.httpMethod isEqualToString:@"DELETE"] && [self.delegate respondsToSelector:@selector(service:didDelete:)])
            [self.delegate service:self didDelete:nil];
        else if ([request.httpMethod isEqualToString:@"PUT"] && [self.delegate respondsToSelector:@selector(service:didUpdate:)])
            [self.delegate service:self didUpdate:objectList];
    } else {
        
        switch (request.operationType) {
            case SocializeRequestOperationTypeUpdate:
                if ([self.delegate respondsToSelector:@selector(service:didUpdate:)]) {
                    [self.delegate service:self didUpdate:objectList];
                }
                break;
            default:
                NSAssert(NO, @"Unhandled operation type %d", request.operationType);
        }
    }
}

- (void)failWithError:(NSError*)error {
    if([self.delegate respondsToSelector:@selector(service:didFail:)]) {
        [self.delegate service:self didFail:error];
    }
}

-(void) dispatch:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    //Move the following lines to the base  SocializeService Class, because it's the same for all objects.
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if(request.expectedJSONFormat == SocializeAny)
        [self invokeAppropriateCallback:request objectList:nil errorList:nil];
    
    else if(request.expectedJSONFormat == SocializeDictionaryWithListAndErrors){
        
        // if it is the response form {errors:"",items:""}
        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
        id jsonObject = [jsonKitDecoder objectWithData:data];
        if (![jsonObject isKindOfClass:[NSDictionary class]])
        {
            // the return object was not what was supposed to be, soo erroring out.
            [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected a Dictionary"]];
            return;
        }
        NSString* errors = [jsonObject objectForKey:@"errors"];
        NSString* items = [jsonObject objectForKey:@"items"];
        
        if (!errors || !items){
            // we should atleast have elements for erors and items in them.
            [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Incomplete Response Dictionary"]];
            return;
        }
        
        id objectResponse = [_objectCreator createObjectFromString:items forProtocol:[self ProtocolType]]; 
        id errorResponses = [_objectCreator createObjectFromString:errors forProtocol:@protocol(SocializeError)]; 
        
        if ([errorResponses isKindOfClass: [NSArray class]]){
            if ([errorResponses count]){
                // Only treat server errors as failure if at least one exists
                [self failWithError:[NSError socializeServerReturnedErrorsErrorWithErrorsArray:errorResponses objectsArray:objectResponse]];
                return;
            }
        }
        
        if([objectResponse isKindOfClass: [NSArray class]]){ 
            if ([objectResponse count]) {
                if ([[objectResponse objectAtIndex:0] conformsToProtocol:[self ProtocolType]]) {
                    [self invokeAppropriateCallback:request objectList:objectResponse errorList:errorResponses];
                } else {
                    [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Object did not conform to expected data protocol"]];
                }
            }
            else {
                [self invokeAppropriateCallback:request objectList:objectResponse errorList:errorResponses];
            }
        }
        else {
            [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected an Array"]];
        }
    }
    else if (request.expectedJSONFormat == SocializeDictionary) {
        id objectResponse = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]]; 
        if ([objectResponse conformsToProtocol:[self ProtocolType]]) {
            [self invokeAppropriateCallback:request objectList:objectResponse errorList:nil];
        } else {
            [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Object did not conform to expected data protocol"]];
        }
    }
    else if (request.expectedJSONFormat == SocializeList){
        //  NSString* items = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]];
        id objectResponse = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]]; 
        
        if([objectResponse isKindOfClass: [NSArray class]]){ 
            if ([objectResponse count]){
                if ([[objectResponse objectAtIndex:0] conformsToProtocol:[self ProtocolType]])
                    [self invokeAppropriateCallback:request objectList:objectResponse errorList:nil];
                else {
                    [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Object did not conform to expected data protocol"]];
                }
            } else {
                [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected List of One or More Items (Found None)"]];
            }
        } else {
            [self failWithError:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected an Array"]];
        }
    }
}

-(void)retainDelegate {
    [_delegate retain];
}

-(void)freeDelegate
{
    [_delegate release];//Release ownership 
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    [self removeRequest:request];
    [self dispatch:request didLoadRawResponse:data];
    [self freeDelegate];
}

-(void)doDidReceiveSocializeObject:(id<SocializeObject>)objectResponse
{}

-(void)doDidReceiveReceiveListOfObjects:(NSArray *)objectResponse
{}

-(void)doDidFailWithError:(NSError *)error
{}


-(NSMutableDictionary*) generateParamsFromJsonString: (NSString*) jsonData
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            jsonData, @"jsonData",
            nil];
}


@end
