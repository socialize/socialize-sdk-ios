/*
 * URLDownloadOperationTests.m
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
 */

#import "URLDownloadOperationTests.h"
#import "URLDownloadOperation.h"
#import <OCMock/OCMock.h>

@interface URLDownloadOperationTests()
-(id) prepareMockConnectionForTest;
-(void) fakeUrlSelector: (NSString*) url;
@end

@implementation URLDownloadOperationTests

-(void) fakeUrlSelector: (NSString*) url
{
    
}

-(id)prepareMockConnectionForTest
{
    id mockConnection = [OCMockObject mockForClass: [NSURLConnection class]];
    [[mockConnection expect] cancel];
    return mockConnection;
}

-(void)testCanncelOperation
{
    URLDownloadOperation* operation = [[URLDownloadOperation alloc] initWithTarget:self selector:@selector(fakeUrlSelector:) connection:nil];
    
    id mockConnection = [self prepareMockConnectionForTest];
    operation.urlConnection = mockConnection;
    [operation cancel];
    [mockConnection verify];
    
    [operation release];
}

@end
