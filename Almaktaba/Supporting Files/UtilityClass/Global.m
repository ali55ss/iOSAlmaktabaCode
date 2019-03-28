//
//  Global.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Global.h"
NSString *const MFDemoErrorDomain = @"MFDemoErrorDomain";
NSInteger const MFDemoErrorCode = 100;

@implementation Global


/**
 Open Side Bar Menu
 */
void openSideBarMenuFrom(UIViewController *vc){
    if (isAppLanguageRightToLeft()) {
        [vc.sideMenuViewController presentRightMenuViewController];
    }else{
        [vc.sideMenuViewController presentLeftMenuViewController];
    }
}



/**
 set Corner Radius
 */
void setCornerRadius(CALayer* layer,float cornerRadious,float borderWidth,UIColor* borderColor,BOOL shadow){
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:cornerRadious];
    [layer setBorderColor:borderColor.CGColor];
    [layer setBorderWidth:borderWidth];
    if (shadow) {
        [layer setMasksToBounds:NO];
        layer.cornerRadius = cornerRadious; // if you like rounded corners
        layer.shadowOffset = CGSizeMake(1,1);
        layer.shadowRadius = 5;
        layer.shadowOpacity = 0.5;
    }
}

/**
 UITextField Padding
 */
#pragma mark- UITextField Padding
void leftPadding(UITextField* txtField){
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    [txtField setLeftViewMode:UITextFieldViewModeAlways];
    [txtField setLeftView:paddingView];
}

/**
 trimmedString
 */
#pragma mark - trimmedString
NSString* trimmedString(NSString* currentString){
    currentString = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 SIAlertView
 */
#pragma mark - SIAlertView
void showAlertWithErrorMessage(NSString *message){
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:LocalizedString(message)];
    
    [alertView addButtonWithTitle:_static_OK
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    
    [alertView show];
}
void showVerificationMessage(NSString* msg){
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:msg];
    
    [alertView addButtonWithTitle:_static_OK
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}
void showAlertWithCustomErrorMessage(NSString *title,NSString *message,NSString *btnTitle){
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:LocalizedString(title) andMessage:LocalizedString(message)];
    
    [alertView addButtonWithTitle:btnTitle
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    
    [alertView show];
}

+(void)showAlertWithError:(NSString *)error andMessage:(NSString *)message {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:LocalizedString(error) andMessage:LocalizedString(message)];
    
    [alertView addButtonWithTitle:_static_OK
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    
    [alertView show];
}

/**
 Error Messages
 */
#pragma mark -  NSError

+ (NSError *)errorWithLocalizedDescription:(NSString *)localizedDescription
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
    return [NSError errorWithDomain:MFDemoErrorDomain code:MFDemoErrorCode userInfo:userInfo];
}

/**
 Check RTL
 */
#pragma mark -  Check RTL
BOOL isAppLanguageRightToLeft() {
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        return YES;
    }
    return NO;
}

/**
 Check Email
 */
#pragma mark -  Check EMAIL is valid or not
+(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

/**
 SHOW HUD
 */
#pragma mark -  ShowHUD
+(void)ShowHUDwithAnimation:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegateObj.window endEditing:YES];

        if (appDelegateObj.hud == nil) {
            appDelegateObj.hud = [[YBHud alloc]initWithHudType:DGActivityIndicatorAnimationTypeFiveDots];
        }
        
        appDelegateObj.hud.dimAmount = 0.7;
        [appDelegateObj.hud showInView:appDelegateObj.window animated:animated];

       
        
    });
    
}
+(void)HideHUDwithAnimation:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appDelegateObj.hud) {
            [appDelegateObj.hud dismissAnimated:!animated];
        }
        
        
    });
    
}

/**
 SaveAuthKeywithEmail
 */
#pragma mark -  SaveAuthKeywithEmail
+(void)SaveAuthKeywithEmail:(NSString *)strEmail ApiKey:(NSString *)key {
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",strEmail,key];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    
    [userDefaults setValue:authValue forKey:userdefaultAuthHeader];
    
    [userDefaults synchronize];
    NSLog(@"This is basic authentication : %@",[userDefaults valueForKey:userdefaultAuthHeader]);
}

/**
 ProgressHUD
 */
#pragma mark -  ProgressHUD
+(void)showProgressHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegateObj.window endEditing:YES];
        
//        [ProgressHUD hudColor:theme_Black_Color];
//        [ProgressHUD backgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
//        [ProgressHUD statusColor:theme_Black_Color];
//
//        [ProgressHUD hudColor:theme_Black_Color];
//        [ProgressHUD spinnerColor:theme_Black_Color];
//
//        [ProgressHUD show:@"Please Wait" Interaction:NO];
        
        /*[SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        [SVProgressHUD setBackgroundColor:svProgreesHUDColor];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD showWithStatus:_loader_Please_Wait];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];*/
    });
}
+(void)showProgressHUDWithSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegateObj.window endEditing:YES];
        
//        [ProgressHUD hudColor:theme_Black_Color];
//        [ProgressHUD backgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
//        [ProgressHUD statusColor:theme_Black_Color];
//
//        [ProgressHUD hudColor:theme_Black_Color];
//        [ProgressHUD spinnerColor:theme_Black_Color];
//
//        [ProgressHUD showSuccess:@"Success!"];
//
        
       /* [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD setBackgroundColor:svProgreesHUDColor];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD showSuccessWithStatus:@"Success!"];*/
        
//        [Global HideHUDwithAnimation:YES];
    });
    
}

+(void)dismissProgressHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [ProgressHUD dismiss];
//        [SVProgressHUD dismiss];
//        [Global HideHUDwithAnimation:YES];
    });
}

/**
 generateRandomPassword
 */
#pragma mark -  generateRandomPassword
+ (NSMutableString *)generateRandomPassword
{
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
    static NSString *digits = @"0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:6];
    for (NSUInteger i = 0; i < 2; i++) {
        uint32_t r;
        r = arc4random_uniform((uint32_t)[letters length]);
        [s appendFormat:@"%C", [letters characterAtIndex:r]];
        r = arc4random_uniform((uint32_t)[digits length]);
        [s appendFormat:@"%C", [digits characterAtIndex:r]];
        r = arc4random_uniform((uint32_t)[letters length]);
        [s appendFormat:@"%C", [letters characterAtIndex:r]];
    }
    return s;
}

/**
 Compress Video in law quality
 */
#pragma mark -  Compress Video

+ (void)compressVideo:(NSURL*)inputURL
            outputURL:(NSURL*)outputURL
              handler:(void (^)(AVAssetExportSession *session))completion  {
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPresetLowQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie; //AVFileTypeAppleM4V;//
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        completion(exportSession);
    }];
}

+(UIImage *)generateThumbImage : (NSURL*)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

/**
 Remove Temp Video File before new create
 */
+(void) clearVideoCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    error=nil;
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temporaryPreview.mov"];
    NSLog(@"filePath to remove = %@",filePath);
    
    BOOL removed =[fileManager removeItemAtPath:filePath error:&error];
    if(removed ==NO)
    {
        NSLog(@"removed ==NO");
    }
    if(error)
    {
        NSLog(@"%@", [error description]);
    }
}


/**
 Check substring in array
 */
+ (BOOL)array:(NSArray *)array containsSubstring:(NSString *)substring {
    
    BOOL containsSubstring = NO;
    
    for (NSString *string in array) {
        
        if ([string rangeOfString:substring].location != NSNotFound) {
            containsSubstring = YES;
            break;
        }
    }
    return containsSubstring;
}


#pragma mark- runAfterDelay
/**
 Hold Some Time
 */
+ (void)runBlock:(void (^)(void))block
{
    block();
}
+ (void)runAfterDelay:(CGFloat)delay block:(void (^)(void))block
{
    void (^block_)(void) = [block copy] ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 delay * NSEC_PER_SEC),
                   dispatch_get_main_queue(),
                   ^{
                       [self runBlock:block_];
                       // Do whatever you want here.
                   });
}
+ (NSDictionary*) objectFromDataWithKey:(NSString*)key {
    NSData *data = [userDefaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end









@implementation PDFDocument

- (id) initWithURL: (NSURL*) url {
    if ([super init])
    {
        // Open PDF
        CGPDFDocumentRef doc = CGPDFDocumentCreateWithURL((CFURLRef)url);
        
        if (doc == NULL)
            @throw @"PDF File does not exist.";
        
        pdfFile = doc;
        
    }
    return self;
}

- (UIImage*) imageForPage: (size_t) pageno size: (CGSize) size {
    if (pdfFile) {
        // Get First Page
        CGPDFPageRef page = CGPDFDocumentGetPage(pdfFile, pageno);
        
        if (page == NULL)
            @throw @"Page does not exist.";
        
        // Get Page Size
        CGRect cropBox = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
        
        // Start Drawing Context to Render PDF
        UIGraphicsBeginImageContext(size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        
        CGRect u = { {0, 0}, size};
        
        CGContextFillRect(context, u);
        CGContextSetAllowsAntialiasing(context, NO);
        
        CGContextSaveGState(context);
        
        // Scale PDF
        CGContextScaleCTM(context, size.width / cropBox.size.width, size.height / cropBox.size.height);
        
        // Flip Context to render PDF correctly
        CGContextTranslateCTM(context, 0.0, cropBox.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextDrawPDFPage(context, page);
        CGContextRestoreGState(context);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext(); // must retain?
        
        UIGraphicsEndImageContext();
        
        return img;
        
    }
    return nil;
}

- (CGSize) sizeOfPage: (size_t) pageno {
    if (pdfFile) {
        CGPDFPageRef page = CGPDFDocumentGetPage(pdfFile, pageno);
        
        if (page == NULL)
            @throw @"Page does not exist";
        
        CGRect cropBox = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
        
        return cropBox.size;
    }
    
    @throw @"No document loaded.";
}

@end

