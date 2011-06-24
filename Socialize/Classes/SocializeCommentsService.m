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

#import "JSONKit.h"
#import "SocializeCommentsService.h"
#import "SocializeComment.h"
#import "SocializeProvider.h"
#import "SocializeCommentJSONFormatter.h"
#import "SocializeObjectFactory.h"

#define COMMENTS_LIST_METHOD @"comment/"

#define IDS_KEY @"ids"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"
#define COMMENT_KEY @"text"


@interface SocializeCommentsService()
    -(void) parseCommentsList: (NSArray*) commentsJsonData;
@end

@implementation SocializeCommentsService

@synthesize delegate = _delegate;
@synthesize provider = _provider;
@synthesize objectCreator = _objectCreator;

-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeCommentsServiceDelegate>) delegate
{
    self = [super init];
    if(self != nil)
    {
        self.provider = provider;
        self.objectCreator = objectFactory;
        self.delegate = delegate;
    }
    
    return self;
}

-(void) dealloc
{
    self.delegate = nil;
    self.provider = nil;
    self.objectCreator = nil;
    [super dealloc];
}

-(void) getCommentById: (int) commentId
{
    [_provider requestWithMethodName:[NSString stringWithFormat:@"comment/%d/",commentId] andParams:nil andHttpMethod:@"GET" andDelegate:self];
}

-(void) getCommentsList: (NSArray*) commentsId
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:commentsId, IDS_KEY, nil];
    [_provider requestWithMethodName:COMMENTS_LIST_METHOD andParams:params andHttpMethod:@"GET" andDelegate:self];
}

-(void) getCommentList: (NSString*) entryKey
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:entryKey, ENTRY_KEY, nil];   
    [_provider requestWithMethodName:COMMENTS_LIST_METHOD andParams:params andHttpMethod:@"GET" andDelegate:self];
}

-(void) createCommentForEntityWithKey: (NSString*) entityKey comment: (NSString*) comment
{
    NSArray *params = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:entityKey, ENTITY_KEY, comment, COMMENT_KEY, nil],
                      nil];
    
    [_provider requestWithMethodName: COMMENTS_LIST_METHOD andParams:params andHttpMethod:@"POST" andDelegate:self];
}

-(void) createCommentForEntity: (id<SocializeEntity>) entity comment: (NSString*) comment createNew: (BOOL) new
{
    if(new)
    {
        NSDictionary* newEntity = [NSDictionary dictionaryWithObjectsAndKeys:entity.key, @"key", entity.name, @"name", nil];
        NSArray *params = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:newEntity, ENTITY_KEY, comment, COMMENT_KEY, nil],
                       nil];
    
        [_provider requestWithMethodName: COMMENTS_LIST_METHOD andParams:params andHttpMethod:@"POST" andDelegate:self];
    }
    else
        [self createCommentForEntityWithKey:entity.key comment:comment];
}

#pragma mark - Socialize request delegate

//- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response
//{
//    // TODO:: add implementation notify that call success. 
//}

- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    [_delegate didFailService:self withError:error];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    id responseObject = [responseString objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    if([responseObject isKindOfClass: [NSDictionary class]])
    {
        id<SocializeComment> comment = [_objectCreator createObjectFromDictionary:responseObject forProtocol:@protocol(SocializeComment)];
        [_delegate receivedComment: self comment:comment];    
    }
    else if([responseObject isKindOfClass: [NSArray class]])
    {
        [self parseCommentsList: responseObject];
    }
    else
    {
        [_delegate didFailService:self withError:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }       
}

-(void) parseCommentsList: (NSArray*) commentsJsonData
{
    NSMutableArray* comments = [NSMutableArray arrayWithCapacity:[commentsJsonData count]];
    [commentsJsonData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         id<SocializeComment> comment = [_objectCreator createObjectFromDictionary:obj forProtocol:@protocol(SocializeComment)];
         [comments addObject:comment];
     }
    ];
    
    [_delegate receivedComments:self comments:comments];
}

@end
