//
// Created by Denis Jajčević on 02.03.2014..
// Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import "JFContext.h"


@implementation JFContextBeanResolver

- (id)beanNamed:(NSString *)name
{
    id bean = self.beanContext[name];
    return bean;
}

- (id)initWithContext:(JFContext *)context
{
    self = [super init];
    if (self) {
        self.context               = context;
        self.beanContextDefinition = self.context.context[kBeansContextKey];
        [self initializeBeanContext];
    }
    return self;
}

- (void)initializeBeanContext
{
    self.beanContext = [NSMutableDictionary new];
    for (NSString *key in self.beanContextDefinition) {
        NSDictionary *beanDictionary = self.beanContextDefinition[key];
        [self initializeBeanNamed:key withDefinition:beanDictionary];
    }
}

- (void)initializeBeanNamed:(NSString *)name withDefinition:(NSDictionary *)dictionary
{
    if (dictionary == nil) {
        return;
    }
    NSMutableDictionary *beanDefinition = [dictionary mutableCopy];

    // get the class name from definition
    Class clazz = NSClassFromString(beanDefinition[kClassKey]);
    if (clazz != nil) {
        // remove "class" value so we can iterate through keys
        [beanDefinition removeObjectForKey:kClassKey];
        // create bean
        id bean = [clazz new];
        if (bean) {
            // add bean to context
            self.beanContext[name] = bean;
            // iterate through remaining keys in bean definition
            // NOTICE: keys are not ordered as defined in context configuration
            for (NSString *key in beanDefinition) {
                // get value from definition
                id value = beanDefinition[key];

                // make a mutable copy so that we can modify the key
                NSMutableString *mutableKey = [key mutableCopy];

                // check if the key defines that the value is boolean
                if ([key hasPrefix:kBooleanPrefix]) {
                    [self processBoolean:bean value:value mutableKey:mutableKey];
                    continue;
                }
                if ([value isKindOfClass:[NSString class]]) {
                    // make a mutable copy of a string value
                    NSMutableString *mutableValue = [value mutableCopy];

                    // selector
                    if ([key hasPrefix:kSelectorPrefix]) {
                        [self processSelector:bean value:value mutableKey:mutableKey];
                    }
                            // bundle value (string value)
                    else if ([mutableValue hasPrefix:kBundlePrefix]) {
                        [self processBundle:name bean:bean key:key value:value mutableValue:mutableValue];
                    }
                    else {
                        [bean setValue:value forKeyPath:key];
                    }
                }
                else {
                    [bean setValue:value forKeyPath:key];
                }
            }
        }
    }

}

- (void)processBundle:(NSString *)name bean:(id)bean key:(NSString *)key value:(id)value
         mutableValue:(NSMutableString *)mutableValue
{
    [self prepareKey:mutableValue prefix:kBundlePrefix];
    NSRange colonLocation = [mutableValue rangeOfString:@":"];
    if (colonLocation.location != NSNotFound) {
        // get configuration file name
        NSString *configurationName = [mutableValue substringToIndex:colonLocation.location];
        if ([configurationName length] == 0) {
            NSLog(@"Configuration for bean %@ failed: configuration file for property value not found. [value = %@]", name, value);
        }
        else {
            // get configuration key
            NSString *configurationPropertyName = [mutableValue substringFromIndex:colonLocation.location + colonLocation.length];

            // get configuration value
            NSString *resultValue = [self.context localizedStringForKey:configurationPropertyName value:nil table:configurationName];

            if (resultValue == nil || [resultValue isEqualToString:configurationPropertyName]) {
                NSLog(@"Warning: configuration for bean %@ failed: configuration file or key for property value not found. [value = %@]", name, value);

            }
            // set the value
            [bean setValue:resultValue forKeyPath:key];
        }
    }
    else {
        NSLog(@"Value for key '%@' not found", value);
    }
}

- (void)processSelector:(id)bean value:(id)value mutableKey:(NSMutableString *)mutableKey
{
    [self prepareKey:mutableKey prefix:kSelectorPrefix];
    SEL selector = NSSelectorFromString(mutableKey);
    if (selector != NULL && [bean respondsToSelector:selector]) {
        [bean performSelector:selector withObject:value];
    }
}

- (void)processBoolean:(id)bean value:(id)value mutableKey:(NSMutableString *)mutableKey
{
    // remove boolean prefix
    [self prepareKey:mutableKey prefix:kBooleanPrefix];
    // get BOOL value
    BOOL     boolean = [value boolValue];
    NSNumber *number = @(boolean);
    [bean setValue:number forKeyPath:mutableKey];
}

/**
* Searches prefix in string and removes it. Eq. with mutableKey="b:test" and prefix="b:" gives result="test"
*/
- (void)prepareKey:(NSMutableString *)mutableKey prefix:(NSString *)prefix
{
    NSRange range;
    range.length   = prefix.length;
    range.location = 0;
    [mutableKey deleteCharactersInRange:range];
}


@end

@implementation JFContext {

}

+ (JFContext *)instance
{
    static JFContext *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.beanResolver = [[JFContextBeanResolver alloc] initWithContext:_instance];
        }
    }

    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.bundleCache   = [NSMutableDictionary new];
        self.configuration = kContextKey;
        self.context       = [NSMutableDictionary dictionaryWithContentsOfFile:[[self localBundle] pathForResource:self.configuration ofType:kPlistKey]];
    }

    return self;
}

+ (NSBundle *)loadBundleNamed:(NSString *)bundleName
{
    NSBundle            *bundleForClass = [self localBundle];
    JFContext           *context        = [self instance];
    NSMutableDictionary *cache          = context.bundleCache;
    NSBundle            *bundle         = [cache objectForKey:bundleName];
    if (bundle == nil) {
        NSString *path      = [bundleForClass pathForResource:bundleName ofType:kLprojKey];
        NSBundle *newBundle = [NSBundle bundleWithPath:path];
        cache[bundleName] = newBundle;
        return newBundle;
    }
    else {
        return bundle;
    }
}

static NSBundle *bundleForClass;

+ (NSBundle *)localBundle
{
    if (bundleForClass == nil) {
        bundleForClass = [NSBundle bundleForClass:[self class]];
    }
    return bundleForClass;
}

- (NSBundle *)localBundle
{
    if (bundleForClass == nil) {
        bundleForClass = [NSBundle bundleForClass:[self class]];
    }
    return bundleForClass;
}

- (NSString *)profilePropertyValueWithKey:(NSString *)key profile:(NSString *)profile
                          andDefaultValue:(NSString *)defaultValue
{

    return [self.profileBundle localizedStringForKey:key value:defaultValue table:kCONFIG_TABLE];
}

+ (NSBundle *)bundleNamed:(NSString *)name
{
    if (name == nil) {
        return [NSBundle mainBundle];
    }
    else {
        return [self loadBundleNamed:name];
    }
}

+ (NSBundle *)profileBundle
{

    return [[self instance] profileBundle];
}

- (NSBundle *)profileBundle
{
    if (_profileBundle == nil) {
#ifdef JF_ACTIVE_PROFILE
        NSString *activeProfile = JF_ACTIVE_PROFILE;
        _profileBundle = [[self class] loadBundleNamed:activeProfile];
#endif
    }
    return _profileBundle;
}


+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    return [[[self class] instance] localizedStringForKey:key value:value table:tableName];
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if (tableName != nil) {
        if ([tableName isEqualToString:kLocalizableKey]) {
            return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
        }
        return [[self profileBundle] localizedStringForKey:key value:value table:tableName];
    }
    return [[self profileBundle] localizedStringForKey:key value:value table:kCONFIG_TABLE];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // get method signature for selector of this class
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        // this class can not respond to aSelector
        // we can assume that the bean is what we are looking for so we return beanNamed: selector as target selector
        signature = [self.beanResolver methodSignatureForSelector:@selector(beanNamed:)];
    }
    return signature;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // we are now looking for bean with selector as name
    SEL sel = anInvocation.selector;

    // get string representation from selector
    NSString *key = NSStringFromSelector(sel);

    // set beanNamed: as target selector
    anInvocation.selector = @selector(beanNamed:);

    // set the argument value
    [anInvocation setArgument:&key atIndex:2];

    // invoke beanNamed: method on resolver
    [anInvocation invokeWithTarget:self.beanResolver];
    // from here, the return value is set
}


@end