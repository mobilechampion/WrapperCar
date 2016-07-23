//
//  AppDelegate.h
//  HeartCMS
//
//  Created by HaoYun Jin on 10/2/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IAP  @"com.app.car.pro"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readwrite, nonatomic) BOOL   iS_Garage;
@property (readwrite, nonatomic) int   car_number;
@end
