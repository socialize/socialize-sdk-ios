/*
 * SocializeShareBuilderTests.m
 * SocializeSDK
 *
 * Created on 11/3/11.
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
 * See Also: http://gabriel.github.com/gh-unit/
 */

#import "SocializeShareBuilderTests.h"
#import "SocializeShareBuilder.h"
#import "ShareProviderProtocol.h"
#import "Socialize.h"

@interface TestShareProvider : NSObject<ShareProviderProtocol> {
    BOOL _success;
}
+(TestShareProvider*)createSuccessProvider:(BOOL)key;

@end

@implementation TestShareProvider

+(TestShareProvider*)createSuccessProvider:(BOOL)key
{
    TestShareProvider* provider = [[TestShareProvider new] autorelease];
    provider->_success = key;
    return provider;
}

- (void)requestWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params httpMethod:(NSString*)httpMethod completion:(void (^)(id result, NSError *error))completion
{
    if (_success) {
        NSDictionary* outArgs = [NSDictionary dictionaryWithObject:@"" forKey:@"id"];
        completion(outArgs, nil);
    }
    else
    {
        completion(nil, [NSError errorWithDomain:@"" code:4040 userInfo:nil]);   
    }
}
@end

@interface SocializeShareBuilderTests()
-(id)generateMockSocializeShareWithEntityKey:(NSString*)key andApplicationName:(NSString*)name;
-(id)generateMockSocializeLikeWithEntityKey:(NSString*)key andApplicationName:(NSString*)name;
-(id)generateMockSocializeCommentWithEntityKey:(NSString*)key andApplicationName:(NSString*)name andComment:(NSString*)text;
@end

@implementation SocializeShareBuilderTests

-(id)generateMockSocializeShareWithEntityKey:(NSString*)key andApplicationName:(NSString*)name
{  
    SocializeEntity* mockEntity = [[SocializeEntity new]autorelease];
    mockEntity.key = key;
       
    SocializeApplication* mockApplication = [[SocializeApplication new] autorelease];
    mockApplication.name = name;
    
    SocializeShare* mockShare = [[SocializeShare new] autorelease];
    mockShare.entity = mockEntity;
    mockShare.application = mockApplication;
    
    return mockShare;
}


-(id)generateMockSocializeLikeWithEntityKey:(NSString*)key andApplicationName:(NSString*)name
{
    SocializeEntity* mockEntity = [[SocializeEntity new]autorelease];
    mockEntity.key = key;
    
    SocializeApplication* mockApplication = [[SocializeApplication new] autorelease];
    mockApplication.name = name;
    
    SocializeLike* mockLike = [[SocializeLike new] autorelease];
    mockLike.entity = mockEntity;
    mockLike.application = mockApplication;
    
    return mockLike;
}

-(id)generateMockSocializeCommentWithEntityKey:(NSString*)key andApplicationName:(NSString*)name andComment:(NSString*)text
{
    SocializeEntity* mockEntity = [[SocializeEntity new]autorelease];
    mockEntity.key = key;
    
    SocializeApplication* mockApplication = [[SocializeApplication new] autorelease];
    mockApplication.name = name;
    
    SocializeComment* mockComment = [[SocializeComment new] autorelease];
    mockComment.entity = mockEntity;
    mockComment.application = mockApplication;
    mockComment.text = text;
    
    return mockComment;
}

-(void)testBuildShareForEntity
{ 

    id mockShareProtocol = [OCMockObject partialMockForObject:[TestShareProvider createSuccessProvider:YES]];    
    [[mockShareProtocol expect] requestWithGraphPath:OCMOCK_ANY params:OCMOCK_ANY httpMethod:@"POST" completion:OCMOCK_ANY];

//        [self.shareProtocol requestWithGraphPath:path params:params httpMethod:@"POST" completion:^(id response, NSError *error) {
    
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc] init] autorelease];
    builder.shareProtocol = mockShareProtocol;   
    builder.shareObject = [self generateMockSocializeShareWithEntityKey:@"test" andApplicationName:@"test"];
    [builder performShareForPath:@"me/feed"];

    
    [mockShareProtocol verify];
}

-(void)testBuildShareForLike
{  
    id mockShareProtocol = [OCMockObject partialMockForObject:[TestShareProvider createSuccessProvider:YES]];    
    [[[mockShareProtocol expect]andForwardToRealObject]requestWithGraphPath:@"me/feed" params:OCMOCK_ANY httpMethod:@"POST" completion:OCMOCK_ANY];
    
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc] init] autorelease];
    builder.shareProtocol = mockShareProtocol;   
    builder.shareObject = [self generateMockSocializeLikeWithEntityKey:@"test" andApplicationName:@"test"];
    [builder performShareForPath:@"me/feed"];
    
    [mockShareProtocol verify];
}

-(void)testBuildShareForComment
{    
    id mockShareProtocol = [OCMockObject partialMockForObject:[TestShareProvider createSuccessProvider:YES]];    
    [[mockShareProtocol expect]requestWithGraphPath:@"me/feed" params:OCMOCK_ANY httpMethod:@"POST" completion:OCMOCK_ANY];
    
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc] init] autorelease];
    builder.shareProtocol = mockShareProtocol;   
    builder.shareObject = [self generateMockSocializeCommentWithEntityKey:@"test" andApplicationName:@"test" andComment:@"test"];
    [builder performShareForPath:@"me/feed"];
    
    [mockShareProtocol verify];
}

-(void)testBuildShareForEntityWithApplicationLink
{
    id mockShareProtocol = [OCMockObject partialMockForObject:[TestShareProvider createSuccessProvider:YES]];    
    [[[mockShareProtocol expect]andForwardToRealObject]requestWithGraphPath:@"me/feed" params:OCMOCK_ANY httpMethod:@"POST" completion:OCMOCK_ANY];
    
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc] init] autorelease];
    builder.shareProtocol = mockShareProtocol;   
    builder.shareObject = [self generateMockSocializeShareWithEntityKey:@"test" andApplicationName:@"test"];
    [builder performShareForPath:@"me/feed"];
    
    [mockShareProtocol verify];
}

-(void)testBuildShareWithCallbacks
{
    id mockShareProtocol = [OCMockObject partialMockForObject:[TestShareProvider createSuccessProvider:YES]];    
    [[[mockShareProtocol expect]andForwardToRealObject]requestWithGraphPath:@"me/feed" params:OCMOCK_ANY httpMethod:@"POST" completion:OCMOCK_ANY];
    
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc] initWithSuccessAction:^(){} andErrorAction:^(NSError* error){}] autorelease];
    builder.shareProtocol = mockShareProtocol;   
    builder.shareObject = [self generateMockSocializeShareWithEntityKey:@"test" andApplicationName:@"test"];
    [builder performShareForPath:@"me/feed"];
    
    [mockShareProtocol verify];
}

-(void)testBuildShareWithCallbacksFailed
{
    id mockShareProtocol = [OCMockObject partialMockForObject:[TestShareProvider createSuccessProvider:NO]];    
    [[[mockShareProtocol expect]andForwardToRealObject]requestWithGraphPath:@"me/feed" params:OCMOCK_ANY httpMethod:@"POST" completion:OCMOCK_ANY];
    
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc] initWithSuccessAction:^(){} andErrorAction:^(NSError* error){GHAssertNotNil(error, nil);}] autorelease];
    builder.shareProtocol = mockShareProtocol;   
    builder.shareObject = [self generateMockSocializeShareWithEntityKey:@"test" andApplicationName:@"test"];
    [builder performShareForPath:@"me/feed"];
    
    [mockShareProtocol verify];
}

-(void)testInitWithCallback
{
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc]initWithSuccessAction:^(){} andErrorAction:^(NSError* error){}] autorelease]; 
    GHAssertNotNil(builder.successAction, nil);
    GHAssertNotNil(builder.errorAction, nil);
}

- (void)performShareWithShareObject:(id)shareObject paramsVerifyBlock:(BOOL (^)(id))paramsVerifyBlock {
    
    id mockShareProtocol = [OCMockObject mockForProtocol:@protocol(ShareProviderProtocol)];
    [[mockShareProtocol expect] requestWithGraphPath:@"me/feed" params:[OCMArg checkWithBlock:paramsVerifyBlock] httpMethod:@"POST" completion:OCMOCK_ANY];
    
    SocializeShareBuilder* builder = [[[SocializeShareBuilder alloc] init] autorelease];
    builder.shareProtocol = mockShareProtocol;
    builder.shareObject = shareObject;
    [builder performShareForPath:@"me/feed"];
    
    [mockShareProtocol verify];
}

- (void)performCommentShareWithParamsVerifyBlock:(BOOL (^)(id))paramsVerifyBlock {
    id mockComment = [self generateMockSocializeCommentWithEntityKey:@"testKey" andApplicationName:@"myapp" andComment:@"something"];
    [self performShareWithShareObject:mockComment paramsVerifyBlock:paramsVerifyBlock];
}

- (void)performLikeShareWithParamsVerifyBlock:(BOOL (^)(id))paramsVerifyBlock {
    id mockLike = [self generateMockSocializeLikeWithEntityKey:@"testKey" andApplicationName:@"myapp"];
    [self performShareWithShareObject:mockLike paramsVerifyBlock:paramsVerifyBlock];
}

- (void)performShareShareWithParamsVerifyBlock:(BOOL (^)(id))paramsVerifyBlock {
    id mockLike = [self generateMockSocializeShareWithEntityKey:@"testKey" andApplicationName:@"myapp"];
    [self performShareWithShareObject:mockLike paramsVerifyBlock:paramsVerifyBlock];
}

- (BOOL (^)(id))doesNotContainSocializeBlock {
    return ^(id params) {
        NSString *message = [params objectForKey:@"message"];
        return (BOOL)![[message lowercaseString] containsString:@"socialize"];
    };
}

- (BOOL (^)(id))containsSocializeBlock {
    return ^(id params) {
        NSString *message = [params objectForKey:@"message"];
        return [[message lowercaseString] containsString:@"socialize"];
    };
}

- (void)testCommentPostDoesNotContainSocializeIfFlagDisabled {
    [Socialize storeDisableBranding:YES];
    [self performCommentShareWithParamsVerifyBlock:[self doesNotContainSocializeBlock]];
    
}

- (void)testCommentPostDoesContainSocializeIfFlagDisabled {
    [Socialize storeDisableBranding:NO];
    [self performCommentShareWithParamsVerifyBlock:[self containsSocializeBlock]];    
}

- (void)testLikePostDoesNotContainSocializeIfFlagDisabled {
    [Socialize storeDisableBranding:YES];
    [self performLikeShareWithParamsVerifyBlock:[self doesNotContainSocializeBlock]];
    
}

- (void)testLikePostDoesContainSocializeIfFlagDisabled {
    [Socialize storeDisableBranding:NO];
    [self performLikeShareWithParamsVerifyBlock:[self containsSocializeBlock]];    
}

- (void)testSharePostDoesNotContainSocializeIfFlagDisabled {
    [Socialize storeDisableBranding:YES];
    [self performShareShareWithParamsVerifyBlock:[self doesNotContainSocializeBlock]];
    
}

- (void)testSharePostDoesContainSocializeIfFlagDisabled {
    [Socialize storeDisableBranding:NO];
    [self performShareShareWithParamsVerifyBlock:[self containsSocializeBlock]];    
}


@end
