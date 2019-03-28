//
//  WebServicesClass.m
//  GymTymer
//
//  Created by TechnoMac-7 on 12/08/16.
//  Copyright © 2016 TechnoMac-10. All rights reserved.
//

#import "WebServicesClass.h"
#import "AppDelegate.h"
#import "Global.h"
//#import "StringConstant.h"
//#import "Devices.h"
#import "LoginVC.h"

@implementation WebServicesClass

static WebServicesClass* _sharedWebServiceCom = nil;

+ (WebServicesClass *) sharedWebServiceClass
{
    @synchronized([WebServicesClass class])
    {
        if (!_sharedWebServiceCom)
            _sharedWebServiceCom = [[self alloc] init];
        
        return _sharedWebServiceCom;
    }
    return nil;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        
        // initialize stuff here
    }
    return self;
}

#pragma mark - POST method

-(void)JsonCallWithImage:(NSData *)imageData withfieldName:(NSString *)strfieldName ClassURL:(NSString *)urlClass WitCompilation:(void (^)(NSMutableDictionary *Dictionary,NSError *error))completion
{
    //NSError *error;
    [appDelegateObj.window endEditing:YES];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString *FileParamConstant = strfieldName;
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlBase,urlClass]];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data

    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"abc.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:url];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if (!error) {
                                                  NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                  if (completion)
                                                      completion(dicjson,error);
                                              } else  {
                                                  if (completion)
                                                      completion(nil,error);
                                              }
                                          }];
    [postDataTask resume];
}

-(void)JsonCallWithFileData:(NSData *)data withfieldName:(NSString *)strfieldName withfileExtention:(NSString *)strfileExtention ClassURL:(NSString *)urlClass withLoading:(BOOL)loading WitCompilation:(void (^)(NSMutableDictionary *Dictionary))completion{
    if (loading) {
            [Global ShowHUDwithAnimation:YES];
    }
    //NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

      NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"---------------------------14737809831466499882746641449";//@"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString *FileParamConstant = strfieldName;
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlBase,urlClass]];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
//    [request setTimeoutInterval:300];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    
    if (data) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",FileParamConstant,TimeStamp,strfileExtention] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:url];

//    NSURLSessionUploadTask *uploadTask = [session         uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //Perform operations on your response here
//    }];
//    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithStreamedRequest:request];
    
    
    /*NSURLSessionUploadTask *uploadTask = [session         uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Perform operations on your response here
        
        if (!error) {
            NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@",dicjson);
            //[KSToastView ks_showToast:@"Success"];
            if (loading) {
                [Global HideHUDwithAnimation:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion){
                    completion(dicjson);
                }
            });
        } else {
            if (loading) {
                [Global HideHUDwithAnimation:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showFailureMessage:error];
                if (completion)
                    completion(nil);
            });
        }
    }];
    
    //Don't forget this line ever
    [uploadTask resume];*/
    
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //[Global HideHUDwithAnimation:YES];
        if (!error) {
            NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@",dicjson);
               //[KSToastView ks_showToast:@"Success"];
            if (loading) {
                [Global HideHUDwithAnimation:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{

                if (completion){
                    completion(dicjson);
                }
            });
        } else {
            if (loading) {
                [Global HideHUDwithAnimation:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{

                [self showFailureMessage:error];
                if (completion)
                    completion(nil);
            });
        }
    }];
    [postDataTask resume];
}



/*-(void)callWebserviceToUploadDocParams:(NSMutableDictionary *)_params docParams:(NSMutableDictionary *)_docParams docType:(NSString*)_docType action:(NSString *)_action success:(void (^)(id))_success failure:(void (^)(NSError *))_failure{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        NSString *urlString = [BASE_URL stringByAppendingString:_action];
        NSLog(@"URL : %@",urlString);
        
        [_params setValue:DEVICE_ID forKey:@"device_id"];
        [_params setValue:DEVICE_TOKEN forKey:@"device_token"];
        [_params setValue:DEVICE_TYPE forKey:@"device_type"];
        
        [_params setValue:user_id() forKey:USER_ID];
        [_params setValue:user_token() forKey:USER_TOKEN];
        
        NSLog(@"PARAMS : %@",_params);
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:urlString]];
        [urlRequest setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // [urlRequest setValue:contentType forHTTPHeaderField:@"Content-type: application/json"]
        NSMutableData *body = [NSMutableData data];
        [_params enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSString *object, BOOL *stop) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",object] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        
        [_docParams enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSData *object, BOOL *stop) {
            if ([object isKindOfClass:[NSData class]]) {
                if (object.length > 0) {
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    NSLog(@"Timestamp:%@",TimeStamp);
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",key,TimeStamp,_docType] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[NSData dataWithData:object]];
                }
                
            }
        }];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:body];
        AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = nil;
        manager.requestSerializer.timeoutInterval = 120.0f;
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if( _failure )
                {
                    _failure( error) ;
                }
            } else {
                
                NSLog(@"response = %@", responseObject);
                if( _success ){
                    if ([[responseObject valueForKey:STATUS_CODE] intValue] == 401) {
                        [theAppDelegate userLogout];
                    }else{
                        _success( responseObject ) ;
                    }
                }
            }
        }];
        
        [dataTask resume];
    }else{
        [Utility showInterNetConnectionMessage];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        NSError *error;
        if( _failure ){
            _failure( error) ;
        }
    }
}*/
-(void)JsonCall:(NSDictionary *)dicData ClassURL:(NSString *)urlClass withLoading:(BOOL)loading showToastOnSuccess:(BOOL)isShowToast WitCompilation:(void (^)(id _responseObject))completion{
    
    if (loading) {
            [Global ShowHUDwithAnimation:YES];
    }
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlBase,urlClass]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy   timeoutInterval:60.0];
    NSLog(@"API : %@",url);
    NSLog(@"Params : %@",dicData);
    
    //    NSLog(@"%@",[userDefaults objectForKey:userdefaultAuthHeader]);
    if ([userDefaults objectForKey:userdefaultAuthHeader]) {
        NSLog(@"Authorization : %@",[userDefaults objectForKey:userdefaultAuthHeader]);
        [request setValue:[userDefaults objectForKey:userdefaultAuthHeader] forHTTPHeaderField:@"Authorization"];
    }
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithDictionary:dicData];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@",dicjson);
            if (loading) {
                [Global HideHUDwithAnimation:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion){
                    if ([[dicjson valueForKey:APIStatusParam] intValue] == successCode ) {
                        if (isShowToast) {
//                            [KSToastView ks_showToast:[dicjson valueForKey:APIMessageParam]];
                             [Global showAlertWithError:appName andMessage:[dicjson valueForKey:APIMessageParam]];
                        }
                        
                        completion(dicjson);
                    }else if ([[dicjson valueForKey:APIStatusParam] intValue] == 201){
                        completion(dicjson);
                        
//                        QueryModel *model2 = [[QueryModel alloc] initWithClass:[Devices class]];
//                        [model2 registerDeviceInfoWithDeviceToken:@"ABC" withCompletion:^(NSDictionary *responseDic) {
//                            if (responseDic) {
//
//                            }
//                        }];
                    }else if ([[dicjson valueForKey:APIStatusParam] intValue] == 401){
                         [Global showAlertWithError:appName andMessage:[dicjson valueForKey:APIMessageParam]];
                        [self logout];
                        completion(nil);

                    }else if ([[dicjson valueForKey:APIStatusParam] intValue] == 300){
                        [Global showAlertWithError:appName andMessage:[dicjson valueForKey:APIMessageParam]];
                        completion(dicjson);
                    }
                    else{
                        [Global showAlertWithError:appName andMessage:[dicjson valueForKey:APIMessageParam]];
                        
                        completion(nil);
                    }
                }
            });
        } else {
            if (loading) {
                [Global HideHUDwithAnimation:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFailureMessage:error];
                if (completion)
                    completion(nil);
            });
        }
    }];
    [postDataTask resume];
}
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{

//    NSLog(@"Progress : %0.2lld",bytesSent/totalBytesExpectedToSend);

    NSInteger percentage = (double)totalBytesSent * 100 / (double)totalBytesExpectedToSend;
    NSLog(@"%@ %ld",_static_Progress,(long)percentage);

    dispatch_async(dispatch_get_main_queue(), ^{
        
        // basic usage
        [appDelegateObj.window makeToast:[NSString stringWithFormat:@"%@ %ld %@",_static_uploadDone,(long)percentage,@"%"]];
        
        if (_uploadProgress) {
            _uploadProgress (percentage);
        }
});
   
}
-(void)notifyUploadProgress:(UploadProgress)callBack{
    self.uploadProgress = callBack;
}

#pragma mark - GET method

-(void)JsonCallGET:(NSString *)urlString WitCompilation:(void (^)(NSMutableDictionary *Dictionary))completion {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:urlBase];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if (!error)  {
                                                  NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                  NSLog(@"%@",dicjson);
                                                  if (completion)
                                                      completion(dicjson);
                                              } else {
                                                  NSMutableDictionary *dicjson = [[NSMutableDictionary alloc]init];
                                                  if (completion)
                                                      completion(dicjson);
                                              }
                                          }];
    [postDataTask resume];
}

-(void)showFailureMessage:(NSError*)error{
    if ([[error description] rangeOfString:@"The request timed out."].location != NSNotFound)
    {
        showAlertWithErrorMessage(@"The request timed out, please verify your internet connection and try again.");
    }
    else if ([[error description] rangeOfString:@"The server can not find the requested page"].location != NSNotFound || [[error description] rangeOfString:@"A server with the specified hostname could not be found."].location != NSNotFound)
    {
        showAlertWithErrorMessage(@"Unable to reach to the server, please try again after few minutes");
    }
    else if([[error description] rangeOfString:@"The network connection was lost."].location != NSNotFound)
    {
        showAlertWithErrorMessage(@"The network connection was lost, please try again.");
        
    }
    else if([[error description] rangeOfString:@"The Internet connection appears to be offline."].location != NSNotFound)
    {
        showAlertWithErrorMessage(@"The Internet connection appears to be offline.");
        
    }
    else if([[error description] rangeOfString:@"JSON text did not start with array or object and option to allow fragments not set."].location != NSNotFound)
    {
        showAlertWithErrorMessage(@"Server error!");
        
    }
    else
    {
        showAlertWithErrorMessage(@"Unable to connect, please try again!");
        
    }
}


#pragma mark- Logout
-(void)logout{
   
    NSString *email = [userDefaults valueForKey:_static_REMEMBER_EMAIL];
    NSString *password = [userDefaults valueForKey:_static_REMEMBER_PASSWORD];
    BOOL remind = [userDefaults boolForKey:_static_IS_REMEMBER_AUTH];
    [userDefaults removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    [userDefaults setBool:NO forKey:_static_IS_ALLREADY_LOGEDIN];
    [userDefaults synchronize];
    
    [userDefaults setValue:email forKey:_static_REMEMBER_EMAIL];
    [userDefaults setValue:password forKey:_static_REMEMBER_PASSWORD];
    [userDefaults setBool:remind forKey:_static_IS_REMEMBER_AUTH];

    [userDefaults setBool:NO forKey:_static_USER_ENROLLED_DEPT];
    [userDefaults removeObjectForKey:_static_userdepartments];

    [userDefaults setBool:NO forKey:_static_IS_LOGEDIN_AS_GUEST];
    
    [userDefaults synchronize];
    
    UINavigationController *navlogin = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginNavControll"];
    
    appDelegateObj.window.rootViewController = navlogin;
    
//    UINavigationController *nav = (UINavigationController*) appDelegateObj.window.rootViewController;
//    NSMutableArray *viewControllerArray = [nav.viewControllers mutableCopy];
//    if (viewControllerArray.count > 1) {
//           [viewControllerArray removeAllObjects];
//    }
//    [viewControllerArray addObject:navlogin];
//    [nav setViewControllers:viewControllerArray animated:NO];
    
}
-(void)pushSelectedSlideMenuViewControler :(UIViewController*)vc {
//    UINavigationController *navController = (UINavigationController *)theAppDelegate.centerViewControllerMain;
//    [ob removeExtraViewControllerFromNavigation:navController];
//    [navController pushViewController:vc animated:NO];
    
}
- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location { 
    
}

@end
