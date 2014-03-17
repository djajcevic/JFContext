//
//  JFAppDelegate.h
//  JFContext
//
//  Created by Denis Jajčević on 02.03.2014..
//  Copyright (c) 2014 JF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFServiceEndpointAuthorizationDelegate.h"

@interface JFAppDelegate : UIResponder <UIApplicationDelegate, JFServiceEndpointAuthorizationDelegate>

@property(strong, nonatomic) UIWindow *window;

@end