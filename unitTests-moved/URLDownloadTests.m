/*
 * URLDownloadTests.m
 * SocializeSDK
 *
 * Created on 8/31/11.
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
 * See Also: http://gabriel.github.com/gh-unit/
 */

#import "URLDownloadTests.h"
#import "URLDownload.h"
#import "URLDownloadOperation.h"
#import <OCMock/OCMock.h>

#define URL @"some_image_url"

@implementation URLDownloadTests

- (void) urlDownloadCompleteWithSuccess:(NSData *)data urldownload:(URLDownload *)urldownload tag:(NSObject *)tag
{
    GHAssertNotNil(urldownload, nil);
    GHAssertNil(tag, nil);
    
    GHAssertTrue([data isEqual:[NSData data]], nil);
    
}

- (void) urlDownloadCompleteWithError:(NSData *)data urldownload:(URLDownload *)urldownload tag:(NSObject *)tag
{
    GHAssertNotNil(urldownload, nil);
    GHAssertNil(tag, nil);

    GHAssertNil(data, nil);    
}

- (void)testDownloadUrl
{
    id mockDownloadOperation = [OCMockObject mockForClass: [URLDownloadOperation class]];
    OperationFactoryBlock testFactotyBlockForOperation =  ^ URLDownloadOperation* (id target, SEL method, id object){
        return  mockDownloadOperation;
    };

    id mockDownloadQueue = [OCMockObject mockForClass: [NSOperationQueue class]];
    [[mockDownloadQueue expect]addOperation: mockDownloadOperation];
    
    URLDownload* loader = [[URLDownload alloc] initWithURL:URL sender:self selector:@selector(urlDownloadCompleteWithSuccess:urldownload:tag:) tag:nil downloadQueue:mockDownloadQueue operationFactory: testFactotyBlockForOperation];
    
    [mockDownloadQueue verify];
    [mockDownloadOperation verify];
    
    [loader release];
}

-(void)testStartDownload
{
    URLDownload* loader = [[[URLDownload alloc] init] autorelease];

    id mockConnection = [OCMockObject mockForClass: [NSURLConnection class]];
    [(NSURLConnection*)[mockConnection expect] start];
    id loaderPartialMock=[OCMockObject partialMockForObject:loader];
    [[loaderPartialMock expect] runCurrentLoopForTimeInterval:[OCMArg any]];    
    //perform the method call
    [loader performSelector:@selector(startDownload:)withObject: mockConnection];
    [loaderPartialMock verify];
    [mockConnection verify];
}

-(void)testCompleteLoadWithSuccess
{
    URLDownload* loader = [[URLDownload alloc] initWithURL:URL sender:self selector:@selector(urlDownloadCompleteWithSuccess:urldownload:tag:) tag:nil downloadQueue:nil operationFactory: nil];
    
    [loader connection:nil didReceiveData:[NSData data]];
    [loader connectionDidFinishLoading:nil];
    [loader release];
    
}

-(void)testCompleteLoadWithError
{
    URLDownload* loader = [[URLDownload alloc] initWithURL:URL sender:self selector:@selector(urlDownloadCompleteWithError:urldownload:tag:) tag:nil downloadQueue:nil operationFactory: nil];
  
    [loader connection:nil didFailWithError:[NSError errorWithDomain:@"test" code:401 userInfo:nil]];
    [loader release];
    
}

-(void) testCreateStaticQueue
{
    GHAssertNotNil([URLDownload downloadQueue], nil);
}

-(void) testCancelDownload
{
    URLDownload* loader = [[[URLDownload alloc] init] autorelease];
    
    id mockDwnQueue = [OCMockObject mockForClass: [NSOperationQueue class]];
    [[mockDwnQueue expect]cancelAllOperations];
    loader.downloadQueue = mockDwnQueue;
    
    [loader cancelDownload];
    
    [mockDwnQueue verify];
}

@end
