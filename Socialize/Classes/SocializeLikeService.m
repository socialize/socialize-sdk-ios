//
//  SocializeLikeService.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeService.h"
#import "JSONKit.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeLike.h"
#import "SocializeObjectFactory.h"
#import "SocializeProvider.h"
#import "SocializeEntity.h"

@interface SocializeLikeService()
-(void)parseLikes:(NSArray*)likesJsonData;
@end

#define LIKE_METHOD @"like/"
#define LIKES_METHOD @"likes/"

@implementation SocializeLikeService


@synthesize delegate = _delegate;
@synthesize provider = _provider;
@synthesize objectCreator = _objectCreator;

-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeLikeServiceDelegate>) delegate
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
    [_objectCreator release]; _objectCreator = nil;
    [super dealloc];
}


- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    [_delegate didFailService:self error:error];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    id responseObject = [responseString objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    if([responseObject isKindOfClass: [NSDictionary class]])
       [_delegate didLikeEntity];    
    else if([responseObject isKindOfClass: [NSArray class]])
       [self parseLikes:responseObject];
    else
       [_delegate didFailService:self error:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
}
    
-(void)parseLikes:(NSArray*)likesJsonData
{
    NSMutableArray* likes = [NSMutableArray arrayWithCapacity:[likesJsonData count]];
    [likesJsonData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
        id<SocializeLike> like = [_objectCreator createObjectFromDictionary:obj forProtocol:@protocol(SocializeLike)];
        [likes addObject:like];
     }
     ];
    
    [_delegate receivedLikes:self likes:likes];
}

-(void)postLikes:(NSArray*)array
{
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    for(id entity in array){
        if ([entity isKindOfClass:[NSString class]]){
            [params setObject:entity forKey:@"entity"];
        }
        else if ([entity conformsToProtocol:@protocol(SocializeEntity)]){
            [params setObject:[entity key]  forKey:@"entity"];
        }
    }
    [_provider requestWithMethodName:LIKES_METHOD andParams:params andHttpMethod:@"POST" andDelegate:self];
}

-(void)deleteLike:(NSInteger)likeId{

    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    [params setObject:[NSNumber numberWithInteger:likeId] forKey:@"id"];
    NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, likeId]; 
    [_provider requestWithMethodName:updatedResource andParams:params andHttpMethod:@"DELETE" andDelegate:self];
    
}

-(void)getLike:(NSInteger)likeId{
    
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    [params setObject:[NSNumber numberWithInteger:likeId] forKey:@"id"];
    NSString* updatedResource = [NSString stringWithFormat:@"%@%d/", LIKE_METHOD, likeId]; 
    [_provider requestWithMethodName:updatedResource andParams:params andHttpMethod:@"GET" andDelegate:self];

}

- (void)getLikes:(NSString*)key, ... {
    
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease]; 
    //  NSInteger eachObject;
    //  va_list argumentList;
    if (key) // The first argument isn't part of the varargs list,
    {                                   // so we'll handle it separately.
        [params setObject:key forKey:@"key"];
    }
    
    /*  va_start(argumentList, key); // Start scanning for arguments after firstObject.
    while ((eachObject = (NSInteger)va_arg(argumentList, NSInteger))){
        [params setObject:[NSNumber numberWithInteger:eachObject] forKey:@"id"];
    }
    */
    // va_end(argumentList);
    [_provider requestWithMethodName:@"likes/" andParams:params andHttpMethod:@"GET" andDelegate:self];
}

@end
