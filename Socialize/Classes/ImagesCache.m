/*
 * ImagesCache.m
 * SocializeSDK
 *
 * Created on 9/8/11.
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

#import "ImagesCache.h"
#import "URLDownload.h"
#import "ImageLoader.h"

@interface ImagesCache()
    - (void) completeLoadHandler:(NSData *)data url:(NSObject *)url;
@end

@implementation ImagesCache

-(id)init
{
    self = [super init];
    if(self)
    {
        imagesDictionary = [[NSMutableDictionary alloc]initWithCapacity:20];
		pendingUrlDownloads = [[NSMutableDictionary alloc]initWithCapacity:20];
    }
    return self;
}

-(void) dealloc
{
    [self stopOperations];
    [imagesDictionary release]; imagesDictionary = nil;
    [pendingUrlDownloads release]; pendingUrlDownloads = nil;
    [super dealloc];
}

-(UIImage*)imageFromCache: (NSString*)url
{
    return (UIImage *)[imagesDictionary objectForKey:url];
}

-(CompleteLoadBlock)createCompleteBlock: (CompleteBlock)cAction
{
    __block ImagesCache* blockSelf = self;
    return [[^(NSString* url, NSData* data)
    {
        [blockSelf completeLoadHandler:data url: url];
        if(cAction)
            cAction(blockSelf);
    }copy]autorelease];
}

-(void)loadImageFromUrl:(NSString*)url withLoader:(Class)loader andCompleteAction:(CompleteBlock)cAction
{
    if([pendingUrlDownloads objectForKey:url])
        return;
    
    NSAssert([loader conformsToProtocol:@protocol(ImageLoaderProtocol)], @"Image Loader should conform to the ImageLoaderProtocol");    
    id loaderInstance = [[loader alloc] init];
    
    [pendingUrlDownloads setObject:loaderInstance forKey:url];
    [loaderInstance startWithUrl:url andCompleteBlock:[self createCompleteBlock:cAction]];
    [loaderInstance release];
}

-(void)stopOperations
{
    [pendingUrlDownloads enumerateKeysAndObjectsUsingBlock:^(id url, id loader, BOOL *stop)
    {
        [loader cancelDownload];
    }];
    
    [pendingUrlDownloads removeAllObjects];
}

-(void)clearCache
{
    [imagesDictionary removeAllObjects];
}

- (void) completeLoadHandler:(NSData *)data url:(NSObject *)url
{
    if (data!= nil) 
	{		
		UIImage *profileImage = [UIImage imageWithData:data];
        [pendingUrlDownloads removeObjectForKey:url];       
		[imagesDictionary setObject:profileImage forKey:url];
	}
}

-(int)imagesCount
{
    return [imagesDictionary count];
}

-(int)pendingCount
{
    return [pendingUrlDownloads count];
}
@end
