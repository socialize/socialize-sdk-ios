/*
 * SocializeShareBuilder.m
 * SocializeSDK
 *
 * Created on 11/2/11.
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

#import "SocializeShareBuilder.h"
#import "Socialize.h"

@interface SocializeShareBuilder()
-(NSMutableDictionary*)prepareApplicationInfoWithLink:(NSString*)link;
-(void)prepareForEntityShare: (NSMutableDictionary*) params;
-(void)prepareForCommentShare: (NSMutableDictionary*) params;
-(void)prepareForLikeShare: (NSMutableDictionary*) params;
@end

@implementation SocializeShareBuilder 
@synthesize shareObject = _shareObject;
@synthesize shareProtocol = _shareProtocol;
@synthesize successAction;
@synthesize errorAction;

-(void)dealloc
{
    self.shareProtocol = nil;
    self.shareObject = nil;
    [successAction release];
    [errorAction release];
    [prepareActions release];
    [super dealloc];
}


-(id)initWithSuccessAction: (OnSuccessAction)success andErrorAction: (OnErrorAction)error
{
    self = [self init];
    if(self)
    {
        successAction = [success copy];
        errorAction = [error copy];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        successAction = nil;
        errorAction = nil;
        
        prepareActions = [[NSDictionary alloc]initWithObjectsAndKeys:
                          NSStringFromSelector(@selector(prepareForEntityShare:)), [SocializeShare class],
                          NSStringFromSelector(@selector(prepareForCommentShare:)), [SocializeComment class],
                          NSStringFromSelector(@selector(prepareForLikeShare:)), [SocializeLike class],
                          nil];
    }
    return self;
}

-(void)performShareForPath:(NSString*)path
{
    NSAssert(self.shareObject != nil, @"Share Object cannot be nil");
    NSAssert(self.shareProtocol != nil, @"Share Protocol cannot  be nil");
    
    NSString *applicationURL = [NSString stringWithSocializeURLForApplication];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              applicationURL, @"link",
              @"Download the app now to join the conversation.", @"caption",
              self.shareObject.application.name, @"name", 
              nil];
    

    SEL prepareSelector = NSSelectorFromString([prepareActions objectForKey:[self.shareObject class]]);
    NSAssert(prepareSelector!= nil, @"This object type does not support");
    
    [self performSelector:prepareSelector withObject:params];
    

    [self.shareProtocol requestWithGraphPath:path params:params httpMethod:@"POST" completion:^(id response, NSError *error) {
        if (error == nil) {
            DebugLog(@"Posted comment with id %@!", [response objectForKey:@"id"]);
            if(successAction)
                successAction();   
        } else {
            DebugLog(@"Failed to post comment! (%@)", [error userInfo]);
            if(errorAction)
                errorAction(error);
        }
        
    }];
}


-(void)prepareForEntityShare: (NSMutableDictionary*) params
{
    id<SocializeShare> share = (id<SocializeShare>)self.shareObject;
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.shareObject.entity];
    NSMutableString* message = [NSMutableString stringWithFormat:@"%@: \n %@", share.text, objectURL];
                                
    if (![Socialize disableBranding]) {
        [message appendFormat:@"\n\n Shared from %@ using Socialize for iOS. \n http://www.getsocialize.com/", share.application.name];
    }
    [params setObject:message forKey:@"message"]; 
}

-(void)prepareForCommentShare: (NSMutableDictionary*) params
{
    id<SocializeComment> comment = (id<SocializeComment>)self.shareObject;
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.shareObject.entity];
    NSMutableString* message = [NSMutableString stringWithFormat:@"%@ \n\n %@", objectURL, comment.text];
    
    if (![Socialize disableBranding]) {
        [message appendFormat:@"\n\n Posted from %@ using Socialize for iOS. \n http://www.getsocialize.com/", comment.application.name];
    }
    [params setObject:message forKey:@"message"];
}

-(void)prepareForLikeShare: (NSMutableDictionary*) params
{
    id<SocializeLike> like = (id<SocializeLike>)self.shareObject;
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.shareObject.entity];
    NSMutableString* message = [NSMutableString stringWithFormat:@"Liked %@", objectURL];
                         
    if (![Socialize disableBranding]) {
        [message appendFormat:@"\n\n Posted from %@ using Socialize for iOS. \n http://www.getsocialize.com/", like.application.name];
    }
    [params setObject:message forKey:@"message"];
}

-(NSMutableDictionary*)prepareApplicationInfoWithLink:(NSString*)link
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            
                                link, @"link",
                                
                                @"Download the app now to join the conversation.", @"caption",
                                
                                self.shareObject.application.name, @"name", 
                                
                                nil];
    return params;
}

@end
