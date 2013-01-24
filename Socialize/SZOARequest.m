//
//  SZOARequest.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequest.h"
#import "socialize_globals.h"
#import "SDKHelpers.h"
#import <OAuthConsumer/OAuthConsumer.h>

@interface SZOARequest ()
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) OAMutableURLRequest *request;
@property (nonatomic, strong) OAAsynchronousDataFetcher *fetcher;
@end

@implementation SZOARequest
@synthesize request = _request;
@synthesize fetcher = _fetcher;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;
@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)dealloc {
    
}

- (id)initWithConsumerKey:(NSString*)consumerKey
           consumerSecret:(NSString*)consumerSecret
                    token:(NSString*)token
              tokenSecret:(NSString*)tokenSecret
                   method:(NSString*)method
                   scheme:(NSString*)scheme
                     host:(NSString*)host
                     path:(NSString*)path
               parameters:(NSDictionary*)parameters
                multipart:(BOOL)multipart
                  success:(void(^)(NSURLResponse*, NSData *data))success
                  failure:(void(^)(NSError *error))failure {
    
    if (self = [super init]) {
        
        OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumerKey secret:consumerSecret];
        OAToken *tokenObject = nil;
        if ([token length] > 0 && [tokenSecret length] > 0) {
            tokenObject = [[OAToken alloc] initWithKey:token secret:tokenSecret];
        }
        
        NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@://%@/%@", scheme, host, trimmedPath]];
        self.request = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:tokenObject realm:@"" signatureProvider:nil];
        
        [self.request setHTTPMethod:method];
        [self.request setHTTPShouldHandleCookies:NO];

        NSMutableArray *oaParams = [NSMutableArray arrayWithCapacity:[parameters count]];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj conformsToProtocol:@protocol(NSFastEnumeration)]) {
                for (id subobject in obj) {
                    [oaParams addObject:[OARequestParameter requestParameterWithName:key value:subobject]];
                }
            } else {
                [oaParams addObject:[OARequestParameter requestParameterWithName:key value:obj]];
            }
        }];
        [self.request setOAParameters:oaParams multipart:multipart];
        
        self.fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:self.request delegate:self didFinishSelector:@selector(fetcherDidFinishWithTicket:data:) didFailSelector:@selector(fetcherDidFailWithTicket:error:)];
        
        self.successBlock = success;
        self.failureBlock = failure;
    }
    
    return self;
}

- (void)setExecuting:(BOOL)executing {
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)setFinished:(BOOL)finished {
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)start {
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.executing = YES;
        
//        [self.request prepare];
//        NSString *body = [[NSString alloc] initWithData:[self.request HTTPBody] encoding:NSASCIIStringEncoding];
//        NSString *urlString = [[self.request URL] absoluteString];
//        SDebugLog(2, @"----- Sending Request -----");
//        SDebugLog(2, @"URL: %@", urlString);
//        SDebugLog(2, @"Headers: %@", [[self request] allHTTPHeaderFields]);
//        //        OAToken *token = [self.request token];
//        //        SDebugLog(2, @"OAuth key: %@, OAuth secret: %@", self.token.key, self.token.secret);
//        //        SDebugLog(2, @"Consumer key: %@, Consumer secret: %@", [SocializeRequest consumerKey], [SocializeRequest consumerSecret]);
//        //        SDebugLog(2, @"Signature Base String: %@", [[self request] _signatureBaseString]);
//        SDebugLog(2, @"Body: %@", body);
//        //        SDebugLog(2, @"Params: %@", _paraams);
//        SDebugLog(2, @"----- End Request ---------");

        [self.fetcher start];
        

    });
}

- (void)cancel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isExecuting]) {
            self.executing = NO;
            [self.fetcher cancel];
        }

        if (![self isFinished]) {
            self.finished = YES;
            NSError *error = [NSError defaultSocializeErrorForCode:SocializeErrorRequestCancelled];
            BLOCK_CALL_1(self.failureBlock, error);
        }
    });
    
    [super cancel];
}

- (void)fetcherDidFinishWithTicket:(OAServiceTicket*)ticket data:(NSData*)data {
    NSHTTPURLResponse *response = ticket.response;
    if ([response statusCode] < 400) {
        BLOCK_CALL_2(self.successBlock, ticket.response, data);
    } else {
        NSString *responseString = NSStringForHTTPURLResponse(ticket.response, data);
        NSError *error = [NSError socializeServerReturnedHTTPErrorErrorWithResponse:ticket.response responseBody:responseString];
        BLOCK_CALL_1(self.failureBlock, error);
    }
    self.executing = NO;
    self.finished = YES;
}

- (void)fetcherDidFailWithTicket:(OAServiceTicket*)ticket error:(NSError*)error {
    BLOCK_CALL_1(self.failureBlock, error);
    
    self.executing = NO;
    self.finished = YES;
}

@end
