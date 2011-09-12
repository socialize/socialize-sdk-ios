/*
 * ImagesCacheTests.m
 * SocializeSDK
 *
 * Created on 9/9/11.
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

#import "ImagesCacheTests.h"
#import "ImagesCache.h"
#import "ImageLoader.h"
#import "OCMock/OCMock.h"

#define TEST_URL @"TestImageUrl"

@interface TestLoader :  GHTestCase<ImageLoaderProtocol>
{
}
-(void) startWithUrl:(NSString*)url andCompleteBlock:(CompleteLoadBlock)block;
-(void) cancelDownload;
@end

@implementation TestLoader

-(void) startWithUrl:(NSString*)url andCompleteBlock:(CompleteLoadBlock)block
{
    GHAssertEqualStrings(TEST_URL, url, nil);
    GHAssertNotNil(block, nil);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"action-bar-icon-like" ofType:@"png"];  
    NSData *testImageData = [NSData dataWithContentsOfFile:filePath];  
    block(url,testImageData);
}

-(void) cancelDownload
{
    
}
@end

@implementation ImagesCacheTests

-(void)testGetImageFromEmptyCache
{
    ImagesCache* cache = [[[ImagesCache alloc] init] autorelease];
    GHAssertNil([cache imageFromCache:@"My Test Image URL"], nil);
}

-(void)testloadImageFromUrl
{
    ImagesCache* cache = [[[ImagesCache alloc] init] autorelease];
        
    [cache loadImageFromUrl:TEST_URL withLoader:[TestLoader class] andCompleteAction:^(ImagesCache* cache){
    
    }];
    
    GHAssertNotNil([cache imageFromCache: TEST_URL], nil);
    
    GHAssertTrue([cache imagesCount] == 1,nil);
    [cache clearCache];
    GHAssertTrue([cache imagesCount] == 0,nil);
}

-(void)testloadImageFromUrlWithBadLoader
{
    ImagesCache* cache = [[[ImagesCache alloc] init] autorelease];
    
    GHAssertThrows([cache loadImageFromUrl:TEST_URL withLoader:[NSObject class] andCompleteAction:^(ImagesCache* cache){
        
    }], nil);
}

-(void)testCancelDownload
{
    ImagesCache* cache = [[[ImagesCache alloc] init] autorelease];
    [cache stopOperations];
    GHAssertTrue([cache pendingCount] == 0, nil);
}

@end
