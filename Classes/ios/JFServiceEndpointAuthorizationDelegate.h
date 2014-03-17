//
// Created by Denis Jajčević on 17.03.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JFServiceEndpointAuthorizationDelegate <NSObject>

- (NSString *)authorizationToken;

@end