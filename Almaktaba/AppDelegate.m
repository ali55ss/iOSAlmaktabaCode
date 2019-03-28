//
//  AppDelegate.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "RootViewController.h"
#import "LARSAdController.h"
#import "TOLAdAdapterGoogleAds.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //LocalizationSetLanguage(@"ar_SA");
    
//    [userDefaults setBool:YES forKey:_static_IS_LOGEDIN_AS_GUEST];
//    [userDefaults synchronize];
    
    [GIDSignIn sharedInstance].clientID = GIDSignInCLIENT_ID;

    [[LARSAdController sharedManager] registerAdClass:[TOLAdAdapterGoogleAds class]
                                      withPublisherId:AdUnitID];
    
    //[[LARSAdController sharedManager] registerAdClass:[TOLAdAdapteriAds class]];
    
    /**
     Hide Keyboard
     */
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    
    /**
     assign Keyboard
     */
    _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    
    /**
     Check user session for login
     */
    if ([userDefaults boolForKey:_static_IS_ALLREADY_LOGEDIN]) {
        [self addSlideMenuAfterLogin];
    }
    
    /**
     Set PDF File Directory
     */
    [[SharedClass sharedManager] setPages:1];
    
    [[SharedClass sharedManager]isCreatePdfFilesFolderInDocuement];
    [[SharedClass sharedManager]isCreateFolderInDocuementForArchiveDocumets];
    
    NSLog(@"Document Path : %@", [[SharedClass sharedManager] documentsPath] );
    

    /**
     @Crash reporter
     */
    [Fabric with:@[[Crashlytics class]]];

    
    // Initialize Google Mobile Ads SDK
    // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
    [GADMobileAds configureWithApplicationID:AdMobAppID];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [Global runAfterDelay:0 block:^{
        if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
            [userDefaults setBool:NO forKey:_static_IS_ALLREADY_LOGEDIN];
            [userDefaults setBool:NO forKey:_static_IS_LOGEDIN_AS_GUEST];
            [userDefaults synchronize];
        }
    }];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@", [url scheme]);
     if([[url scheme] isEqualToString:FACEBOOK_SCHEME]){
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
      }
     else{
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
     }
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}



#pragma mark - Slide Menu manager
-(void)addSlideMenuAfterLogin{
    
//    LoginNavControll *navq = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginNavControll"];
//    [navq popToRootViewControllerAnimated:NO];
//
//    RootViewController *mainvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//    self.window.rootViewController = mainvc;
    
    
    
    RootViewController *mainvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    self.window.rootViewController = mainvc;
    
//    NSMutableArray *viewControllerArray = [nav.viewControllers mutableCopy];
//    [viewControllerArray removeAllObjects];
//    [viewControllerArray addObject:mainvc];
//    [nav setViewControllers:viewControllerArray animated:NO];
}

#pragma mark- Google sign in
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
}


@end
