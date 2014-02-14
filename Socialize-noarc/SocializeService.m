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
#import <SZJSONKit/JSONKit.h>
#import "SocializeError.h"
#import "_Socialize.h"
#import "socialize_globals.h"

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
    [_objectCreator release];
    _objectCreator = nil;
    self.delegate = nil;
    [self cancelAllRequests];
    
    [super dealloc];
}



-(id) initWithObjectFactory: (SocializeObjectFactory*) objectFactory delegate:(id<SocializeServiceDelegate>) delegate
{
    self = [super init];
    if(self != nil)
    {
        _objectCreator = [objectFactory retain];
        self.delegate = delegate;
    }
    
    return self;
}

- (void)cancelAllRequests {
    for (SocializeRequest *request in outstandingRequests_) {
        [request setDelegate:nil];
        [request cancel];
    }
    self.outstandingRequests = nil;    
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

- (void)callEndpointWithPath:(NSString*)path method:(NSString*)method params:(NSMutableDictionary*)params  success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:method
                                                           resourcePath:path
                                                     expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                                                 params:params];
    
    request.successBlock = success;
    request.failureBlock = failure;
    
    [self executeRequest:request];
}

- (void)callListingGetEndpointWithPath:(NSString*)path params:(NSMutableDictionary*)params first:(NSNumber*)start last:(NSNumber*)end success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
    [params setValue:start forKey:@"start"];
    [params setValue:end forKey:@"end"];
    [self callEndpointWithPath:path method:@"GET" params:params success:success failure:failure];
}

#pragma mark - Socialize request delegate
- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error {
    if ([[error domain] isEqualToString:SocializeErrorDomain] && [error code] == SocializeErrorServerReturnedHTTPError) {
        NSHTTPURLResponse *response = [[error userInfo] objectForKey:kSocializeErrorNSHTTPURLResponseKey];
        if ([response statusCode] == 401) {
            [[Socialize sharedSocialize] removeSocializeAuthenticationInfo];
        }
    }

     //[self doDidFailWithError:error];
    [self removeRequest:request];
    
    [self failWithRequest:request error:error];
    
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

- (void)postDidCreateObjectsNotification:(NSArray*)objects {
    NSDictionary *userInfo = objects ? @{ kSZCreatedObjectsKey: objects } : nil;
    NSNotification *notification = [NSNotification notificationWithName:SZDidCreateObjectsNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postDidDeleteObjectsNotification:(NSArray*)objects {
    NSDictionary *userInfo = objects ? @{ kSZDeletedObjectsKey: objects } : nil;
    NSNotification *notification = [NSNotification notificationWithName:SZDidDeleteObjectsNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postDidFetchObjectsNotification:(NSArray*)objects {
    NSDictionary *userInfo = objects ? @{ kSZFetchedObjectsKey: objects } : nil;
    NSNotification *notification = [NSNotification notificationWithName:SZDidFetchObjectsNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)sendNotificationForSelector:(SEL)sel object:(id)object {
    NSArray *objectsArray = object;
    if (object != nil && ![objectsArray isKindOfClass:[NSArray class]]) {
        objectsArray = @[ object ];
    }
    
    if (sel == @selector(service:didCreate:)) {
        [self postDidCreateObjectsNotification:objectsArray];
    } else if (sel == @selector(service:didDelete:)) {
        [self postDidDeleteObjectsNotification:objectsArray];
    } else if (sel == @selector(service:didFetchElements:)) {
        [self postDidFetchObjectsNotification:objectsArray];
    }

}

- (void)invokeBlockOrDelegateCallbackForBlock:(void(^)(id object))block selector:(SEL)sel object:(id)object {
    if (block != nil) {
        block(object);
    }
    
    [self sendNotificationForSelector:sel object:object];
    
    if ([self.delegate respondsToSelector:sel]) {
        
        // Keep some legacy callback service:didCreate: special cases (just for backward compatibility)
        if (sel == @selector(service:didCreate:)) {
            
            if ([object isKindOfClass:[NSArray class]]) {
                if ([object count] == 1) {
                    
                    // Single result is passed as scalar when using callbacks
                    object = [object objectAtIndex:0];
                } else if ([object count] == 0) {
                    
                    // No result passed as nil when using callbacks
                    object = nil;
                }
            }
        }
        
        [self.delegate performSelector:sel withObject:self withObject:object];
    }
}

- (void)invokeCallbackWithRequest:(SocializeRequest*)request object:(id)object selector:(SEL)selector {
    [self invokeBlockOrDelegateCallbackForBlock:request.successBlock selector:selector object:object];
}

-(void)invokeAppropriateCallback:(SocializeRequest*)request objectList:(id)objectList errorList:(id)errorList {

    NSMutableArray* array = [self getObjectListArray:objectList];
    
    if (request.operationType == SocializeRequestOperationTypeInferred) {
    
        if ([request.httpMethod isEqualToString:@"POST"]) {
            [self invokeCallbackWithRequest:request object:array selector:@selector(service:didCreate:)];
        } else if ([request.httpMethod isEqualToString:@"GET"]) {
            [self invokeCallbackWithRequest:request object:array selector:@selector(service:didFetchElements:)];
        } else if ([request.httpMethod isEqualToString:@"DELETE"]) {
            [self invokeCallbackWithRequest:request object:objectList selector:@selector(service:didDelete:)];
        } else if ([request.httpMethod isEqualToString:@"PUT"]) {
            [self invokeCallbackWithRequest:request object:objectList selector:@selector(service:didUpdate:)];
        }
    } else {
        switch (request.operationType) {
            case SocializeRequestOperationTypeUpdate:
                [self invokeCallbackWithRequest:request object:objectList selector:@selector(service:didUpdate:)];
                break;
            default:
                NSAssert(NO, @"Unhandled operation type %d", request.operationType);
        }
    }
}

- (void)failWithRequest:(SocializeRequest*)request error:(NSError*)error {
    if (request.failureBlock != nil) {
        request.failureBlock(error);
    } else if ([self.delegate respondsToSelector:@selector(service:didFail:)]) {
        [self.delegate service:self didFail:error];
    }
}

-(void) dispatch:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    Protocol *protocolType = request.expectedProtocol != nil ? request.expectedProtocol : [self ProtocolType];

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
            [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected a Dictionary"]];
            return;
        }
        NSString* errors = [jsonObject objectForKey:@"errors"];
        NSString* items = [jsonObject objectForKey:@"items"];
        
        if (!errors || !items){
            // we should atleast have elements for erors and items in them.
            [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Incomplete Response Dictionary"]];
            return;
        }
        
        
        id objectResponse = [_objectCreator createObjectFromString:items forProtocol:protocolType]; 
        id errorResponses = [_objectCreator createObjectFromString:errors forProtocol:@protocol(SocializeError)]; 
        
        if ([errorResponses isKindOfClass: [NSArray class]]){
            if ([errorResponses count]){
                // Only treat server errors as failure if at least one exists
                [self failWithRequest:request error:[NSError socializeServerReturnedErrorsErrorWithErrorsArray:errorResponses objectsArray:objectResponse]];
                return;
            }
        }
        
        if([objectResponse isKindOfClass: [NSArray class]]){ 
            if ([objectResponse count]) {
                if ([[objectResponse objectAtIndex:0] conformsToProtocol:protocolType]) {
                    [self invokeAppropriateCallback:request objectList:objectResponse errorList:errorResponses];
                } else {
                    [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Object did not conform to expected data protocol"]];
                }
            }
            else {
                [self invokeAppropriateCallback:request objectList:objectResponse errorList:errorResponses];
            }
        }
        else {
            [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected an Array"]];
        }
    }
    else if (request.expectedJSONFormat == SocializeDictionary) {
        id objectResponse = [_objectCreator createObjectFromString:responseString forProtocol:protocolType]; 
        if ([objectResponse conformsToProtocol:protocolType]) {
            [self invokeAppropriateCallback:request objectList:objectResponse errorList:nil];
        } else {
            [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Object did not conform to expected data protocol"]];
        }
    }
    else if (request.expectedJSONFormat == SocializeList){
        //  NSString* items = [_objectCreator createObjectFromString:responseString forProtocol:[self ProtocolType]];
        id objectResponse = [_objectCreator createObjectFromString:responseString forProtocol:protocolType]; 
        
        if([objectResponse isKindOfClass: [NSArray class]]){ 
            if ([objectResponse count]){
                if ([[objectResponse objectAtIndex:0] conformsToProtocol:protocolType])
                    [self invokeAppropriateCallback:request objectList:objectResponse errorList:nil];
                else {
                    [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Object did not conform to expected data protocol"]];
                }
            } else {
                [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected List of One or More Items (Found None)"]];
            }
        } else {
            [self failWithRequest:request error:[NSError socializeUnexpectedJSONResponseErrorWithResponse:responseString reason:@"Expected an Array"]];
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
