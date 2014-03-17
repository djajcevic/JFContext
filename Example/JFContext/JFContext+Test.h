//
// Created by Denis Jajčević on 03.03.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JFServiceEndpoint;
@class JFURLRequest;

@interface JFContext (Test)
- (JFServiceEndpoint *)testEndpoint;

- (JFURLRequest *)testRequest;
//- (JFServiceEndpoint *) googleService1;
//- (JFServiceEndpoint *) googleService2;
@end