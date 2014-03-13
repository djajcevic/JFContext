//
// Created by Denis Jajčević on 03.03.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFServiceEndpoint : NSObject

@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *method;
@property(nonatomic, assign) BOOL production;
@property(nonatomic, retain) NSDictionary *params;


@end