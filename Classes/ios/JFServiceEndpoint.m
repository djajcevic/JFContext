//
// Created by Denis Jajčević on 03.03.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "JFServiceEndpoint.h"
#import "JFServiceEndpointAuthorizationDelegate.h"

@interface JFServiceEndpoint ()


@end

@implementation JFServiceEndpoint

- (NSString *)authorizationHeaderValue
{
    if ([self.authorizationToken length]) {
        return _authorizationToken;
    }
    else if (_authorizationDelegate != nil) {
        return [_authorizationDelegate authorizationToken];
    }
    else {
        return nil;
    }
}


@end