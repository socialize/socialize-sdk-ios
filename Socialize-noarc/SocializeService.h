/*
 * SocializeService.h
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
#import <Foundation/Foundation.h>
#import "SocializeRequest.h"
#import "SocializeObjectFactory.h"
#import "SocializeUser.h"
#import "SocializeServiceDelegate.h"



@interface SocializeService : NSObject <SocializeRequestDelegate>
{
      @protected    
        SocializeObjectFactory*      _objectCreator;
        id<SocializeServiceDelegate> _delegate;
}
@property (nonatomic, readonly) Protocol * ProtocolType;
@property (nonatomic, assign) id<SocializeServiceDelegate> delegate;
@property (nonatomic, retain) NSMutableSet *outstandingRequests;

-(id) initWithObjectFactory: (SocializeObjectFactory*) objectFactory delegate:(id<SocializeServiceDelegate>) delegate;

- (void)callEndpointWithPath:(NSString*)path method:(NSString*)method params:(NSMutableDictionary*)params  success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)callListingGetEndpointWithPath:(NSString*)path params:(NSMutableDictionary*)params first:(NSNumber*)start last:(NSNumber*)end success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)executeRequest:(SocializeRequest*)request;
-(void)invokeAppropriateCallback:(SocializeRequest*)request objectList:(id)objectList errorList:(id)errorList;
- (void)invokeBlockOrDelegateCallbackForBlock:(void(^)(id object))block selector:(SEL)selector object:(id)object;
-(NSMutableArray *)getObjectListArray:(id)objectList;
-(NSMutableDictionary*)generateParamsFromJsonString:(NSString*)jsonRequest;
-(void)freeDelegate;
-(void)retainDelegate;

//Primitive methods
-(void)doDidReceiveSocializeObject:(id<SocializeObject>)objectResponse;
-(void)doDidReceiveReceiveListOfObjects:(NSArray *)objectResponse;
-(void)doDidFailWithError:(NSError *)error;
- (void)cancelAllRequests;
- (void)failWithRequest:(SocializeRequest*)request error:(NSError*)error;

@end
