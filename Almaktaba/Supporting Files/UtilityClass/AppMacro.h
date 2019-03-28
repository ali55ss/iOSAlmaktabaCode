//
//  AppMacro.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define appName _static_Al_Maktaba


//#define BASE_UNI_LOGO_URL                       @"http://192.168.0.160/api_almaktaba/geturl/university/"
//#define BASE_DOCUMENT_URL                       @"http://192.168.0.160/api_almaktaba/geturl/documents/"
//#define BASE_PROFILE_IMAGE_URL                   @"http://192.168.0.160/api_almaktaba/geturl/profile/"

//#define urlBase @"http://192.168.0.160/api_almaktaba/"



//#define BASE_UNI_LOGO_URL                       @"http://almaktaba.technostacks.com/api/geturl/university/"
//#define BASE_DOCUMENT_URL                       @"http://almaktaba.technostacks.com/api/geturl/documents/"
//#define BASE_PROFILE_IMAGE_URL                  @"http://almaktaba.technostacks.com/api/geturl/profile/"
//
//#define BASE_DOC_VIDEO_URL                  @"http://almaktaba.technostacks.com/api/webroot/1519819345_904951/"

//#define urlBase @"http://almaktaba.technostacks.com/api/"


/**
 Client's account
 */


#define BASE_UNI_LOGO_URL                      @"http://3.18.57.91/api/geturl/university/" //@"http://18.191.4.243/api/geturl/university/"
#define BASE_DOCUMENT_URL                     @"http://3.18.57.91/api/geturl/documents/" // @"http://18.191.4.243/api/geturl/documents/"
#define BASE_PROFILE_IMAGE_URL               @"http://3.18.57.91/api/geturl/profile/"  // @"http://18.191.4.243/api/geturl/profile/"

#define BASE_DOC_VIDEO_URL                  @"http://3.18.57.91/api/webroot/video/"

#define urlBase @"http://3.18.57.91/api/"  //@"http://18.191.4.243/api/"

#define AdUnitID @"ca-app-pub-7466393711815362/7847134157" // test ca-app-pub-3940256099942544/2934735716
#define AdMobAppID  @"ca-app-pub-7466393711815362~7175435914" // test ca-app-pub-3940256099942544~1458002511

#define FACEBOOK_SCHEME                             @"fb618957538495944"

#define GIDSignInCLIENT_ID                          @"842140475741-ch4tee8optc4l1vhjee02pm76efe3djn.apps.googleusercontent.com" // testing.developer4@gmail.com


#define theme_Blue_Color [UIColor colorWithRed:62.0/255 green:62.0/255 blue:116.0/255 alpha:1.0]
#define theme_Light_Gray_Color [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0]
#define theme_Gray_Color [UIColor colorWithRed:185.0/255 green:185.0/255 blue:185.0/255 alpha:1.0]
#define theme_Dark_Gray_Color [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1.0]
#define theme_Red_Color [UIColor colorWithRed:238.0/255 green:31.0/255 blue:31.0/255 alpha:1.0]
#define theme_Black_Color [UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1.0]


#define HeaderColor [UIColor colorWithRed:15.0/255 green:110.0/255 blue:194.0/255 alpha:1.0]
#define ImagevwBorder [UIColor colorWithRed:17.0/255 green:108.0/255 blue:191.0/255 alpha:1.0]   // same as header color
#define btnBGColor [UIColor colorWithRed:30.0/255 green:42.0/255 blue:64.0/255 alpha:1.0]
#define svProgreesHUDColor [UIColor colorWithRed:68.0/255 green:109.0/255 blue:189.0/255 alpha:1.0]

#define appBackgroundColor [UIColor colorWithRed:237.0/255 green:240.0/255 blue:241.0/255 alpha:1.0]

#define tblListBgColor [UIColor colorWithRed:236.0/255 green:241.0/255 blue:241.0/255 alpha:1.0]

#define syncTextColor [UIColor colorWithRed:111.0/255 green:191.0/255 blue:150.0/255 alpha:1.0]

//#define headerColor [UIColor colorWithRed:75.0/255 green:122.0/255 blue:194.0/255 alpha:1.0]

#define appEditBtnBgColor [UIColor whiteColor]


#define TimeStamp [NSString stringWithFormat:@"%.5f",[[NSDate date] timeIntervalSince1970]]

//#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define appDelegateObj ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define isiPhone6 [[UIScreen mainScreen] bounds].size.height == 667

#define isiPhone4 [[UIScreen mainScreen] bounds].size.height == 480

#define isiPhone5 [[UIScreen mainScreen] bounds].size.height == 568

#define isiPhone6P [[UIScreen mainScreen] bounds].size.height == 736
#define PSCLog(fmt, ...) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define compressQuality 0.55

#define NSUDKeySwitchPhoto @"savePhoto"



#define userdefaultAuthHeader @"basicAuthHeader"
#define userDefaults [NSUserDefaults standardUserDefaults]
#define notificationCenter  [NSNotificationCenter defaultCenter]
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height



#endif /* AppMacro_h */
