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
#import "SocializeProvider.h"
#import "SocializeUser.h"
#import "SocializeServiceDelegate.h"



@interface SocializeService : NSObject <SocializeRequestDelegate>
{
      @protected    
        SocializeProvider*           _provider;
        SocializeObjectFactory*      _objectCreator;
        id<SocializeServiceDelegate> _delegate;
}
@property (nonatomic, readonly) Protocol * ProtocolType;
@property (nonatomic, assign) id<SocializeServiceDelegate> delegate;
@property (nonatomic, retain) id provider;

-(id) initWithProvider: (SocializeProvider*) provider objectFactory:(SocializeObjectFactory*) objectFactory delegate:(id<SocializeServiceDelegate>) delegate;

//The methods below should be private methods put in a Private Headers file.
-(void)ExecuteGetRequestAtEndPoint: (NSString *)endPoint  WithParams:(id)requestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat;
-(void)ExecutePostRequestAtEndPoint:(NSString *)endPoint  WithObject:(id)postRequestObject expectedResponseFormat:(ExpectedResponseFormat)expectedFormat;
-(void)ExecutePutRequestAtEndPoint:(NSString *)endPoint  WithObject:(id)putRequestObject expectedResponseFormat:(ExpectedResponseFormat)expectedFormat;
-(void)ExecutePutRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)putRequestParams expectedResponseFormat:(ExpectedResponseFormat)expectedFormat;
-(void)ExecutePostRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)postRequestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat;
-(void)ExecuteDeleteRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)deleteRequestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat;
-(void)ExecuteSecurePostRequestAtEndPoint:(NSString *)endPoint  WithParams:(id)postRequestParameters expectedResponseFormat:(ExpectedResponseFormat)expectedFormat;

-(NSMutableDictionary*)genereteParamsFromJsonString:(NSString*)jsonRequest;
-(void)freeDelegate;

//Primitive methods
-(void)doDidReceiveSocializeObject:(id<SocializeObject>)objectResponse;
-(void)doDidReceiveReceiveListOfObjects:(NSArray *)objectResponse;
-(void)doDidFailWithError:(NSError *)error;

@end
