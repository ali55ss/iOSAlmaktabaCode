//
//  WebServicesClass.h
//  GymTymer
//
//  Created by TechnoMac-7 on 12/08/16.
//  Copyright © 2016 TechnoMac-10. All rights reserved.



// Sandbox API url

#define successCode 200     // API response success code
#define APIMessageParam @"message"
#define APIStatusParam @"code"

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface WebServicesClass : NSObject<NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate,NSURLSessionDownloadDelegate>

+ (WebServicesClass *) sharedWebServiceClass;

// API calling POST method
//-(void)JsonCall:(NSDictionary *)dicData ClassURL:(NSString *)urlClass WitCompilation:(void (^)(NSMutableDictionary *Dictionary,NSError *error))completion;

-(void)JsonCall:(NSDictionary *)dicData ClassURL:(NSString *)urlClass withLoading:(BOOL)loading showToastOnSuccess:(BOOL)isShowToast WitCompilation:(void (^)(id _responseObject))completion;

// API calling GET method
-(void)JsonCallGET:(NSString *)urlString WitCompilation:(void (^)(NSMutableDictionary *Dictionary))completion;

//// API calling Image uplaoding "FormData" request POST
//-(void)JsonCallWithImage:(NSData *)imageData withfieldName:(NSString *)strfieldName ClassURL:(NSString *)urlClass WitCompilation:(void (^)(NSMutableDictionary *Dictionary,NSError *error))completion;

//Upload File
-(void)JsonCallWithFileData:(NSData *)data withfieldName:(NSString *)strfieldName withfileExtention:(NSString *)strfileExtention ClassURL:(NSString *)urlClass withLoading:(BOOL)loading WitCompilation:(void (^)(NSMutableDictionary *Dictionary))completion;

@property (nonatomic, retain) NSMutableData *dataToDownload;
@property (nonatomic) float downloadSize;
-(void)showFailureMessage:(NSError*)error;

typedef void (^UploadProgress)(NSInteger percentage);
@property (copy, nonatomic) UploadProgress uploadProgress;
-(void)notifyUploadProgress:(UploadProgress)callBack;

@end
