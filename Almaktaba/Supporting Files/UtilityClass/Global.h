//
//  Global.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Global : NSObject

/**
 Open Side Bar Menu
 */

void openSideBarMenuFrom(UIViewController *vc);


/**
 set Corner Radius
 */
void setCornerRadius(CALayer* layer,float cornerRadious,float borderWidth,UIColor* borderColor,BOOL shadow);

/**
 UITextField Padding
 */
#pragma mark- UITextField Padding
void leftPadding(UITextField* txtField);


/**
 trimmedString
 */
#pragma mark - trimmedString
NSString* trimmedString(NSString* currentString);

/**
 SIAlertView
 */
#pragma mark - SIAlertView
void showAlertWithErrorMessage(NSString *message);
void showAlertWithCustomErrorMessage(NSString *title,NSString *message,NSString *btnTitle);
void showVerificationMessage(NSString* msg);
+(void)showAlertWithError:(NSString *)error andMessage:(NSString *)message;

/**
 Error Messages
 */
#pragma mark -  NSError

+ (NSError *)errorWithLocalizedDescription:(NSString *)localizedDescription;

/**
 Check RTL
 */
#pragma mark -  Check RTL
BOOL isAppLanguageRightToLeft();

/**
 Check Email
 */
#pragma mark -  Check EMAIL is valid or not
+(BOOL) IsValidEmail:(NSString *)checkString;

/**
 SHOW HUD
 */
#pragma mark -  ShowHUD
+(void)ShowHUDwithAnimation:(BOOL)animated;
+(void)HideHUDwithAnimation:(BOOL)animated;


/**
 SaveAuthKeywithEmail
 */
#pragma mark -  SaveAuthKeywithEmail
+(void)SaveAuthKeywithEmail:(NSString *)strEmail ApiKey:(NSString *)key;


/**
 ProgressHUD
 */
#pragma mark -  ProgressHUD
+(void)showProgressHUD;
+(void)showProgressHUDWithSuccess;
+(void)dismissProgressHUD;


/**
 generateRandomPassword
 */
#pragma mark -  generateRandomPassword
+ (NSMutableString *)generateRandomPassword;


/**
 Compress Video in law quality
 */
#pragma mark -  Compress Video

+ (void)compressVideo:(NSURL*)inputURL
            outputURL:(NSURL*)outputURL
              handler:(void (^)(AVAssetExportSession *session))completion;
+(UIImage *)generateThumbImage : (NSURL*)url;



/**
 Remove Temp Video File before new create
 */
+(void) clearVideoCache;



/**
 Check substring in array
 */
+ (BOOL)array:(NSArray *)array containsSubstring:(NSString *)substring;



#pragma mark- runAfterDelay
/**
 Hold Some Time
 */
+ (void)runAfterDelay:(CGFloat)delay block:(void (^)(void))block;
+ (NSDictionary*) objectFromDataWithKey:(NSString*)key ;
@end




@interface PDFDocument : NSObject {
    CGPDFDocumentRef pdfFile;
}

- (id) initWithURL: (NSURL*) url;
- (UIImage*) imageForPage: (size_t) pageno size: (CGSize) size;
- (CGSize) sizeOfPage: (size_t) pageno;

@end

