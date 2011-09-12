/*
 * ImageLoader.m
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
 */

#import "ImageLoader.h"
#import "URLDownload.h"

@interface UrlImageLoader()
    - (void) completeLoadHandler:(NSData *)data urldownload:(URLDownload *)urldownload tag:(NSObject *)tag;
@end


@implementation UrlImageLoader
@synthesize urlDownload;

-(void)dealloc
{
    [urlDownload release];
    [super dealloc];
}

- (void) completeLoadHandler:(NSData *)data urldownload:(URLDownload *)urldownload tag:(id)tag
{
    CompleteLoadBlock callback = (CompleteLoadBlock)tag;
    callback(urldownload.urlForDownload, data);
}

-(void) startWithUrl:(NSString*)url andCompleteBlock:(CompleteLoadBlock)block
{
    NSAssert(urlDownload == nil, @"Operation has already been started!");
    urlDownload = [[URLDownload alloc] initWithURL:url sender:self 
                                                           selector:@selector(completeLoadHandler:urldownload:tag:) 
                                                                tag:block];
}

-(void) cancelDownload
{
    [urlDownload cancelDownload];
}

@end
