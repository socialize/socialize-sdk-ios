/*
 * SocializeJSONFormatter.h
 * SocializeSDK
 *
 * Created on 6/10/11.
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
#import "SocializeObject.h"

@class  SocializeObjectFactory;


//This probably should be a protocol as well.
@interface SocializeObjectFormatter : NSObject 
{

    @protected
        SocializeObjectFactory * _factory;

}

//@property (nonatomic, readonly) SocializeObjectFactory* objectFactory;

-(id)initWithFactory:(SocializeObjectFactory *) theObjectFactory;

-(void)toObject:(id<SocializeObject>)toObject fromString:(NSString *)stringRepresentation;

//Template Methods
-(void)toObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)dictionaryRepresentation;

-(void)toDictionary:(NSMutableDictionary *)dictionaryRepresentation fromObject:(id<SocializeObject>) fromObject;

-(NSString*)toStringfromObject:(id<SocializeObject>) fromObject;


//Primitive methods
-(void)doToObject:(id<SocializeObject>)toObject fromDictionary:(NSDictionary *)dictionaryRepresentation;

-(void)doToDictionary:(NSMutableDictionary *)dictionaryRepresentation fromObject:(id<SocializeObject>) fromObject;

@end
