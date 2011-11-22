/*
 * SocializeShareBuilder.h
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

#import <Foundation/Foundation.h>
#import "ShareProviderProtocol.h"
#import "SocializeObjects.h"

typedef void (^OnSuccessAction)();
typedef void (^OnErrorAction)(NSError*);

@interface SocializeShareBuilder : NSObject {
@private
    OnSuccessAction successAction;
    OnErrorAction errorAction;
    NSDictionary* prepareActions;
}

-(id)initWithSuccessAction: (OnSuccessAction)success andErrorAction: (OnErrorAction)error;
-(void)performShareForPath:(NSString*)path;

@property(nonatomic, retain) id<ShareProviderProtocol> shareProtocol;
@property(nonatomic, retain) id<SocializeActivity> shareObject;
@property(nonatomic, copy) OnSuccessAction successAction;
@property(nonatomic, copy) OnErrorAction errorAction;

@end
