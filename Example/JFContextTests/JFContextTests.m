//
//  JFContextTests.m
//  JFContextTests
//
//  Created by Denis Jajčević on 02.03.2014..
//  Copyright (c) 2014 JF. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JFContext.h"
#import "JFContext+Test.h"
#import "JFServiceEndpoint.h"

@interface JFContextTests : XCTestCase

@end

@implementation JFContextTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);

//    NSString *string1 = [[JFContext bundleNamed:@"hr"] localizedStringForKey:@"test" value:@"" table:nil];
    NSString          *string2  = [[JFContext bundleNamed:@"en"] localizedStringForKey:@"test" value:@"" table:nil];
//    NSString *string3 = [[JFContext bundleNamed:@"hr"] localizedStringForKey:@"test" value:@"" table:nil];
//    NSString *string4 = [[JFContext profileBundle] localizedStringForKey:@"googleServiceEndpoint" value:@"" table:kCONFIG_TABLE];
    JFServiceEndpoint *service  = [[JFContext instance] googleService];
    JFServiceEndpoint *service1 = [[JFContext instance] googleService1];
    JFServiceEndpoint *service2 = [[JFContext instance] googleService2];
}

@end
