//
//  AppDelegate.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//com.technostacks.almaktaba

#import <UIKit/UIKit.h>
#import "YBHud.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#define appDelegateObj ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//@import GoogleSignIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 Define main storyboard
 */
@property (strong, nonatomic) UIStoryboard *storyboard;

/**
 YBHud is a Process Indicator(Loader).
 */
@property (strong, nonatomic) YBHud *hud;

/**
 ShouldRotate use for check device is rotate enable disable specific screen.
 */
@property (assign, nonatomic) BOOL shouldRotate;



#pragma mark - Slide Menu manager
-(void)addSlideMenuAfterLogin;
@end

