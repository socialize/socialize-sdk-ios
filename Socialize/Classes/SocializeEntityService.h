/*
 * SocializeEntityService.h
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


#import <Foundation/Foundation.h>
#import "SocializeEntity.h"
#import "SocializeRequest.h"

@class SocializeProvider;
@class SocializeObjectFactory;

@protocol SocializeEntityServiceDelegate;

@interface SocializeEntityService : NSObject<SocializeRequestDelegate> 
{
    @private    
        id<SocializeEntityServiceDelegate> _delegate;
        SocializeProvider*  _provider;
        SocializeObjectFactory* _objectCreator;
    
}
//-(void)entityWithKey:(NSString *)keyOfEntity;
//-(void)listEntitiesWithKeys:(NSArray *)entityKeysArray;
-(void)createEntities:(NSArray *)entities;
-(void)createEntity:(id<SocializeEntity>)entity;
-(void)createEntityWithKey:(NSString *)keyOfEntity andName:(NSString *)nameOfEntity;

-(id) initWithProvider: (SocializeProvider*)provider objectFactory: (SocializeObjectFactory*) objectFactory delegate: (id<SocializeEntityServiceDelegate>) delegate;

-(NSMutableDictionary*) genereteParamsFromJsonString: (NSString*) jsonRequest;

@end

@protocol SocializeEntityServiceDelegate

//-(void) entityService:(SocializeEntityService *)entityService didReceiveEntity:(id<SocializeEntity>)entityObject;
-(void) entityService:(SocializeEntityService *)entityService didReceiveListOfEntities:(NSArray *)entityList;
//-(void) entityService:(SocializeEntityService *)entityService didFailWithError:(NSError *)error;

@end
