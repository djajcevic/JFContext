//
// Created by Denis Jajčević on 17.03.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFServiceEndpoint.h"
#import "NSMutableURLRequest+JF.h"
#import "NSString+JF.h"

@interface JFURLRequest : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property(nonatomic, strong) NSURLConnection         *urlConnection;
@property(nonatomic, strong, readonly) NSMutableData *responseData;

@property(nonatomic, strong) JFServiceEndpoint *serviceEndpoint;

@property(nonatomic, strong, readonly) NSError           *error;
@property(nonatomic, strong, readonly) NSHTTPURLResponse *httpUrlResponse;

@property(nonatomic, retain) NSDictionary *params;
@property(nonatomic, retain) NSString     *bodyPayload;

@property(nonatomic, readonly) BOOL done;

- (id)initWithServiceEndpoint:(JFServiceEndpoint *)serviceEndpoint;

- (void)invoke;

- (void)cancel;

- (id)jsonResponseDictionary;

- (NSString *)stringResponseDictionary;
@end