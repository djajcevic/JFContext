//
// Created by Denis Jajčević on 02.03.2014..
// Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+JF.h"

@class JFContext;

@interface JFContextBeanResolver : NSObject

@property(nonatomic, strong) JFContext *context;

@property(nonatomic, strong) NSMutableDictionary *beanContext;

@property(nonatomic, strong) id beanContextDefinition;

- (id)beanNamed:(NSString *)name;

- (id)initWithContext:(JFContext *)context;

@end

#define kCONFIG_TABLE @"config"

#define JFLocalizedString(key, bundle, table)  [[JFContext bundleNamed:(bundle)] localizedStringForKey:(key) value:@"" table:(table)]

#define NSLocalizedStringFromTable(key, comment, table)  JFLocalizedString((key), (comment), (table))


//NSLocalizedStringFromTableInBundle((key), (NSLocalizedStringFromTable), [JFContext profileBundle], (comment))

#define kBeansContextKey @"beans"

#define kBundlePrefix @"bundle:"
#define kSelectorPrefix @"sel:"
#define kBooleanPrefix @"b:"
#define kReferencePrefix @"ref:"

#define kLocalizableKey @"Localizable"
#define kClassKey @"class"
#define kContextKey @"context"
#define kPlistKey @"plist"
#define kInitMethodKey @"initMethod"

#define kLprojKey @"lproj"

@interface JFContext : NSObject
@property(nonatomic, copy) NSString *configuration;

@property(nonatomic, strong) NSBundle *profileBundle;

@property(nonatomic, strong) NSMutableDictionary *bundleCache;

@property(nonatomic, strong) NSMutableDictionary *context;

@property(nonatomic, strong) JFContextBeanResolver *beanResolver;

+ (JFContext *)instance;


- (NSString *)profilePropertyValueWithKey:(NSString *)key profile:(NSString *)profile
                          andDefaultValue:(NSString *)defaultValue;

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;

+ (NSBundle *)bundleNamed:(NSString *)name;

+ (NSBundle *)profileBundle;

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
                              table:(NSString *)tableName NS_FORMAT_ARGUMENT(1);


@end