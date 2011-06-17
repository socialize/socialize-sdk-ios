/*
 * SocializeCommentsService.m
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

#import "SocializeCommentsService.h"
#import "SocializeComment.h"
#import "SocializeProvider.h"
#import "SocializeCommentJSONFormatter.h"

#define COMMENT_METHOD @"comment/"
#define COMMENTS_LIST_METHOD @"comment/list/"
@interface SocializeCommentsService()
    -(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest;
@end

@implementation SocializeCommentsService

@synthesize delegate = _delegate;
@synthesize provider = _provider;
@synthesize commentFormater = _commentFormater;

-(void) dealloc
{
    self.delegate = nil;
    self.provider = nil;
    [_commentFormater release]; _commentFormater = nil;
    [super dealloc];
}

-(void) getCommentById: (int) commentId
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:commentId], @"id",
                                   nil];
    [_provider requestWithMethodName:COMMENT_METHOD andParams:params andHttpMethod:@"GET" andDelegate:self];
}

-(void) getCommentsList: (NSArray*) commentsId
{
    NSString* jsonParams = [_commentFormater commentIdsToJsonString: commentsId];
    NSMutableDictionary* params = [self genereteParamsFromJsonString:jsonParams];

    [_provider requestWithMethodName: COMMENTS_LIST_METHOD andParams:params andHttpMethod:@"POST" andDelegate:self];
}

-(void) getCommentList: (NSString*) entryKey
{
    NSString* jsonParams = [_commentFormater entryKeyToJsonString: entryKey];
    NSMutableDictionary* params = [self genereteParamsFromJsonString:jsonParams];
    
    [_provider requestWithMethodName:COMMENTS_LIST_METHOD andParams:params andHttpMethod:@"POST" andDelegate:self];
}

-(void) postComments:(NSDictionary*)comments
{
    NSString* jsonParams = [_commentFormater commentsFromDictionary: comments];
    NSMutableDictionary* params = [self genereteParamsFromJsonString:jsonParams];
    
    [_provider requestWithMethodName: COMMENT_METHOD andParams:params andHttpMethod:@"PUT" andDelegate:self];
}



#pragma mark - Socialize requst delegate

- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    // TODO:: add implementation
}

- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    if([_delegate respondsToSelector:@selector(didFailService:withError:)])
    {
        [_delegate didFailService:self withError:error];
    }
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    // TODO:: add implementation
}

#pragma mark - Helper methods

-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest
{
    NSData* jsonData =  [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   jsonData, @"jsonData",
                                   nil];
}

@end
