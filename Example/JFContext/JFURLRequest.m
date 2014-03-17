//
// Created by Denis Jajčević on 17.03.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "JFURLRequest.h"

@interface JFURLRequest ()
@property(nonatomic, strong, readwrite) NSMutableData     *responseData;
@property(nonatomic, strong, readwrite) NSError           *error;
@property(nonatomic, strong, readwrite) NSHTTPURLResponse *httpUrlResponse;
@property(nonatomic, readwrite) BOOL                      done;
@end

@implementation JFURLRequest

- (id)initWithServiceEndpoint:(JFServiceEndpoint *)serviceEndpoint
{
    self = [super init];
    if (self) {
        self.serviceEndpoint = serviceEndpoint;
    }
    return self;
}


- (void)invoke
{
    if ([self prepareConnection]) {
        [[self urlConnection] start];
    }
}

- (void)cancel
{
    if (self.urlConnection) {
        [self.urlConnection cancel];
    }
}


- (id)jsonResponseDictionary
{
    if (self.responseData) {
        NSError *error   = nil;
        id      response = [NSJSONSerialization JSONObjectWithData:self.responseData options:NULL error:&error];
        return response;
    }
    return nil;
}

- (NSString *)stringResponseDictionary
{
    return [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
}


- (BOOL)prepareConnection
{
    if (self.serviceEndpoint == nil || [self.serviceEndpoint.address length] == 0) {
        return NO;
    }

    NSURLRequest *request = [self buildRequest];
    if (request) {
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    }
    else {
        return NO;
    }

    return YES;
}

- (NSURLRequest *)buildRequest
{
    NSMutableURLRequest *request = nil;
    NSString            *address = _serviceEndpoint.address;

    if ([self.serviceEndpoint.method isEqualToString:kHTTP_METHOD_POST]) {
        request = [NSMutableURLRequest post:address];
        if (_params) {
            [request body:_params];
        }
        else {
            NSString *bodyPayload = _bodyPayload;
            if ([bodyPayload length]) {
                NSData *bodyData = [bodyPayload dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:bodyData];
            }
        }
        [request setValue:_serviceEndpoint.contentType forHTTPHeaderField:@"Content-Type"];
    }
    else {
        request = [NSMutableURLRequest get:address withPathDictionaryValues:_params];
    }

    NSString *authorizationHeaderValue = _serviceEndpoint.authorizationHeaderValue;
    if (authorizationHeaderValue) {
        [request setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    }

    return request;
}

- (NSURLConnection *)urlConnection
{
    if (_urlConnection == nil) {
        _urlConnection = [NSURLConnection new];
    }
    return _urlConnection;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self responseData] appendData:data];
}

- (NSMutableData *)responseData
{
    if (_responseData == nil) {
        _responseData = [NSMutableData new];
    }
    return _responseData;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.httpUrlResponse = (NSHTTPURLResponse *) response;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.done = YES;
}


@end