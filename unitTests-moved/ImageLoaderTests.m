/*
 * ImageLoaderTests.m
 * SocializeSDK
 *
 * Created on 9/12/11.
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

#import "ImageLoaderTests.h"
#import "ImageLoader.h"
#import "URLDownload.h"
#import <OCMock/OCMock.h>

@implementation ImageLoaderTests

-(void)testConformProtocol
{
    UrlImageLoader* loader = [[[UrlImageLoader alloc] init] autorelease];
    GHAssertTrue([loader conformsToProtocol: @protocol(ImageLoaderProtocol)], nil);
}

-(void)testCancelLoad
{
    UrlImageLoader* loader = [[[UrlImageLoader alloc] init] autorelease];
    
    id mockImpl = [OCMockObject mockForClass: [URLDownload class]];
    [[mockImpl expect] cancelDownload];
    loader.urlDownload = mockImpl;
    
    [loader cancelDownload];
    
    [mockImpl verify];
}

-(void)testStartLoad
{
//    UrlImageLoader* loader = [[[UrlImageLoader alloc] init] autorelease];    
}
@end
