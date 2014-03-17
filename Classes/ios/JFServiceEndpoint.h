//
// Created by Denis Jajčević on 03.03.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JFServiceEndpointAuthorizationDelegate;

#define kHTTP_METHOD_GET @"GET"
#define kHTTP_METHOD_POST @"POST"

@interface JFServiceEndpoint : NSObject

@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *method;
@property(nonatomic, retain) NSString *contentType;

#pragma mark - authorization
@property(nonatomic, retain) NSString                                    *authorizationToken;
@property(readonly) NSString                                             *authorizationHeaderValue;
@property(nonatomic, assign) id <JFServiceEndpointAuthorizationDelegate> authorizationDelegate;


@end