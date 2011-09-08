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

@interface ImagesCache()
- (void) updateProfileImage:(NSData *)data urldownload:(URLDownload *)urldownload tag:(NSObject *)url;
@end

@implementation ImagesCache

-(id)initWithCompleteBlock:(CompleteBlock) block
{
    self = [super init];
    if(self)
    {
        completeAction = [block retain];
        userImageDictionary = [[NSMutableDictionary alloc]initWithCapacity:20];
		pendingUrlDownloads = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return self;
}

-(void) dealloc
{
    [completeAction release]; completeAction = nil;
    [userImageDictionary release]; userImageDictionary = nil;
    [pendingUrlDownloads release]; pendingUrlDownloads = nil;
    [super dealloc];
}

-(UIImage*)imageFromCache: (NSString*)url
{
    return (UIImage *)[userImageDictionary objectForKey:url];
}

-(void)loadImageFromUrl:(NSString*)url
{
    URLDownload* urlDownload =	[[URLDownload alloc] initWithURL:url sender:self 
                                                       selector:@selector(updateProfileImage:urldownload:tag:) 
                                                            tag:url];
    
    [pendingUrlDownloads addObject:urlDownload];
}

-(void)clearCache
{
    for(URLDownload* pendingDownload in pendingUrlDownloads){
        pendingDownload.requestedObject = nil;
        [pendingDownload cancelDownload];
    }
    [pendingUrlDownloads removeAllObjects];
    [userImageDictionary removeAllObjects];
}


- (void) updateProfileImage:(NSData *)data urldownload:(URLDownload *)urldownload tag:(NSObject *)url 
{
	if (data!= nil) 
	{		
		UIImage *profileImage = [UIImage imageWithData:data];
        [pendingUrlDownloads removeObject:urldownload];       
		[urldownload release];
		[userImageDictionary setObject:profileImage forKey:url];
        
        completeAction(self);
	}
}

@end
