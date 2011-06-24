/*
 * SocializeEntityService.m
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

#import "SocializeEntityService.h"
#import "SocializeObjectFactory.h"
#import "SocializeProvider.h"
#import "SocializeEntity.h"


#define ENTITY_GET_ENDPOINT     @"entity/"
#define ENTITY_CREATE_ENDPOINT  @"entity/"
#define ENTITY_LIST_ENDPOINT    @"entity/list/"

#define IDS_KEY @"ids"
#define ENTRY_KEY @"key"
#define ENTITY_KEY @"entity"
#define COMMENT_KEY @"text"


@interface SocializeEntityService()
//-(NSMutableDictionary*) genereteParamsFromJsonString:(NSString*)jsonRequest;
@end

@implementation SocializeEntityService

@synthesize delegate = _delegate;

-(void) dealloc
{
    _delegate = nil;
    _provider = nil;
    _objectCreator = nil;
    [super dealloc];
}

-(id) initWithProvider: (SocializeProvider*) provider objectFactory: (SocializeObjectFactory*) objectFactory delegate:(id<SocializeEntityServiceDelegate>) delegate
{
    self = [super init];
    if(self != nil)
    {
        _provider = provider;
        _objectCreator = objectFactory;
        _delegate = delegate;
    }
    
    return self;
}


//-(void)entityWithKey:(NSString *)keyOfEntity
//{
//    
//}

//-(void)listEntitiesWithKeys:(NSArray *)entityKeysArray
//{
//    NSString * stringRepresentation =  [_objectCreator createStringRepresentationOfArray:entityKeysArray]; 
//    NSMutableDictionary* params = [self genereteParamsFromJsonString:stringRepresentation];
//    [_provider requestWithMethodName:ENTITY_LIST_ENDPOINT andParams:params andHttpMethod:@"POST" andDelegate:self];
//}

-(void)createEntities:(NSArray *)entities
{
    NSString * stringRepresentation =  [_objectCreator createStringRepresentationOfArray:entities]; 
    NSMutableDictionary* params = [self genereteParamsFromJsonString:stringRepresentation];
    [_provider requestWithMethodName:ENTITY_CREATE_ENDPOINT andParams:params andHttpMethod:@"POST" andDelegate:self];
}
-(void)createEntity:(id<SocializeEntity>)entity
{
    [self createEntities:[NSArray arrayWithObject:entity]];
}


-(void)createEntityWithKey:(NSString *)keyOfEntity andName:(NSString *)nameOfEntity
{
    id<SocializeEntity> entity = (id<SocializeEntity>)[_objectCreator createObjectForProtocol:@protocol(SocializeEntity)];
   
    entity.key = keyOfEntity;
    entity.name = nameOfEntity;
   
    [self createEntity:entity];
}

#pragma mark - Socialize requst delegate

//- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response
//{
//    // TODO:: add implementation notify that call success. 
//}

- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    //[_delegate entityService:self didFailWithError:error];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    
    //Move the following lines to the base  SocializeService Class, because it's the same for all objects.
    NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    id entityResponse = [_objectCreator createObjectFromString:responseString forProtocol:@protocol(SocializeEntity)]; 
    
    
    if([entityResponse conformsToProtocol:@protocol(SocializeObject)])
    {
        [_delegate entityService:self didReceiveEntity:(id<SocializeEntity>)entityResponse];
    }
    else if([entityResponse isKindOfClass: [NSArray class]])
    {
        [_delegate entityService:self didReceiveListOfEntities:(NSArray *)entityResponse];  
    }
    else
    {
        [_delegate entityService:self didFailWithError:[NSError errorWithDomain:@"Socialize" code:400 userInfo:nil]];
    }       

}

#pragma mark - Helper methods

-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest
{
    //NSData* jsonData =  [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    NSString * jsonData = jsonRequest;
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            jsonData, @"jsonData",
            nil];
}


@end
