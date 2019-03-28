//
//  QueryModel.m
//  FacialDetection
//
//  Created by TechnoMac-7 on 22/03/17.
//  Copyright © 2017 TechnoMac-7. All rights reserved.
//

#import "QueryModel.h"
#import "WebServicesClass.h"
#import "Global.h"
#import "sys/utsname.h"
@implementation QueryModel

-(id)initWithClassName:(NSString *)classname {
    
    if (!self) {
        self = [super init];
    }
    strClassname = classname;
    dicMain = [NSMutableDictionary dictionary];
    [dicMain setObject:@"all" forKey:parameterGet];
    return self;
}
-(id)initWithClass:(Class)_class {
    
    if (!self) {
        self = [super init];
    }
    strClassname = NSStringFromClass([_class class]);
    dicMain = [NSMutableDictionary dictionary];
    [dicMain setObject:@"all" forKey:parameterGet];
    return self;
}

-(id)initWithClassname:(NSString *)classname AndDict:(NSDictionary *)dicRoom {
    if (!self) {
        self = [super init];
    }
    strClassname = classname;
    dicMain = [NSMutableDictionary dictionary];
    [dicMain setObject:@"all" forKey:parameterGet];
    [dicMain setObject:dicRoom forKey:parameterCondition];
    return self;
}

#pragma mark - Where conditions

-(void)WhereKey:(NSString *)field Equalto:(id)object {
    NSMutableDictionary *dicCondition;
    if ([dicMain objectForKey:parameterCondition]) {
        dicCondition = [[dicMain objectForKey:parameterCondition] mutableCopy];
    } else {
        dicCondition = [NSMutableDictionary dictionary];
    }
    [dicCondition setObject:object forKey:field];
    [dicMain setObject:dicCondition forKey:parameterCondition];
}
#pragma mark - Fields conditions
-(void)SetFields:(NSString *)strObject {
    NSMutableArray *arrayContains;
    if ([dicMain objectForKey:parameterFields]) {
        arrayContains = [[dicMain objectForKey:parameterFields] mutableCopy];
    } else {
        arrayContains = [NSMutableArray array];
    }
    [arrayContains addObject:strObject];
    [dicMain setObject:arrayContains forKey:parameterFields];
}


//{"conditions":{"college_id":"1"},"fields":["Departments.department_name","Departments.id"],"contain":["departments"],"get":"all" }


#pragma mark - add custom param
-(void)CustomParameterWithParam:(NSString *)param WithField:(NSString*)field Equelto:(id)object {
    NSMutableDictionary *dicCondition;
    if ([dicMain objectForKey:param]) {
        dicCondition = [[dicMain objectForKey:param] mutableCopy];
    } else {
        dicCondition = [NSMutableDictionary dictionary];
    }
    [dicCondition setObject:object forKey:field];
    [dicMain setObject:dicCondition forKey:param];
}

-(void)AddObject:(NSString *)field Equelto:(id)object {
    [dicMain setObject:object forKey:field];
}

#pragma mark - Not In Claus

-(void)FieldObjectNotInData:(NSString *)Field andValue:(id)object{
    NSMutableDictionary *dicNoIn;
    if ([dicMain objectForKey:parameterCondition]) {
        dicNoIn = [[dicMain objectForKey:parameterCondition] mutableCopy];
    } else {
        dicNoIn = [NSMutableDictionary dictionary];
        [dicNoIn setObject:object forKey:[NSString stringWithFormat:@"%@ %@",Field,parameterNotIn]];
        [dicNoIn setObject:@"1" forKey:parameterStatus];
        [dicNoIn setObject:@"2" forKey:_static_ROLL_ID];
    }
    [dicMain setObject:dicNoIn forKey:parameterCondition];
}

#pragma mark - Contains Clause

-(void)ContainsObject:(NSString *)strObject {
    NSMutableArray *arrayContains;
    if ([dicMain objectForKey:parameterContains]) {
        arrayContains = [[dicMain objectForKey:parameterContains] mutableCopy];
    } else {
        arrayContains = [NSMutableArray array];
    }
    [arrayContains addObject:strObject];
    [dicMain setObject:arrayContains forKey:parameterContains];
}

#pragma mark - ORDER Clause

-(void)SortinAscendingwithfield:(NSString *)strFieldName {
    NSMutableDictionary *dicOrder;
    if ([dicMain objectForKey:parameterOrder]) {
        dicOrder = [[dicMain objectForKey:parameterOrder] mutableCopy];
    } else {
        dicOrder = [NSMutableDictionary dictionary];
    }
    [dicOrder setValue:@"ASC" forKey:strFieldName];
    [dicMain setObject:dicOrder forKey:parameterOrder];

}

-(void)SortinDescendingwithfiled:(NSString *)strFieldName {
    NSMutableDictionary *dicOrder;
    if ([dicMain objectForKey:parameterOrder]) {
        dicOrder = [[dicMain objectForKey:parameterOrder] mutableCopy];
    } else{
        dicOrder = [NSMutableDictionary dictionary];
    }
    [dicOrder setValue:@"DESC" forKey:strFieldName];
    [dicMain setObject:dicOrder forKey:parameterOrder];

}




#pragma mark -
#pragma mark -
#pragma mark - verify User

-(void)verifyUserWithVarificationCode:(NSDictionary *)dicVarify withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void (^)(NSDictionary *responseDic))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicVarify ClassURL:[NSString stringWithFormat:@"%@/activeaccount.json",strClassname] withLoading:isLoading showToastOnSuccess:isShowToast WitCompilation:^(id _responseObject) {
        if (completion) {
            completion([_responseObject objectForKey:[strClassname capitalizedString]]);
        }
    }];
}

#pragma marl - Forgot password 

-(void)forgotPasswordWithData:(NSDictionary*)reqData withCompletion:(void (^)(NSDictionary *resposeDic))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:reqData ClassURL:[NSString stringWithFormat:@"%@/forgotpassword.json",strClassname] withLoading:YES showToastOnSuccess:YES WitCompilation:^(id _responseObject) {
        if (completion) {
            if([[_responseObject objectForKey:[strClassname capitalizedString]] firstObject]){
                [Global SaveAuthKeywithEmail:[[[_responseObject valueForKey:[strClassname capitalizedString]] firstObject] valueForKey:@"email"] ApiKey:[[[_responseObject valueForKey:[strClassname capitalizedString]] firstObject] valueForKey:@"api_plain_key"]];
                
                completion([[_responseObject objectForKey:[strClassname capitalizedString]] firstObject]);
            }else{
                completion(nil);
            }
        }
    }];
}
-(void)logoutUser:(NSDictionary*)reqData withCompletion:(void (^)(NSDictionary *resposeDic))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:reqData ClassURL:[NSString stringWithFormat:@"%@/logout",strClassname] withLoading:YES showToastOnSuccess:YES WitCompilation:^(id _responseObject) {
        if (completion) {
            completion([_responseObject objectForKey:[strClassname capitalizedString]]);
        }
    }];
}

#pragma mark- Verify OTP
-(void)resendVerificationCodeWithData:(NSDictionary*)reqData withCompletion:(void (^)(NSDictionary *responsedic))completion{
    [[WebServicesClass sharedWebServiceClass] JsonCall:reqData ClassURL:[NSString stringWithFormat:@"%@/resendcode.json",strClassname] withLoading:YES showToastOnSuccess:YES WitCompilation:^(id _responseObject) {
        if (completion) {
            completion([_responseObject objectForKey:[strClassname capitalizedString]]);
        }
    }];
}

#pragma mark - Login with User

-(void)loginwithCredentials:(NSDictionary *)dicCondition WithCompletion:(void (^)(NSDictionary *responsedic))completion {
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicCondition ClassURL:[NSString stringWithFormat:@"%@/login.json",strClassname] withLoading:YES showToastOnSuccess:NO WitCompilation:^(id _responseObject) {
        if (completion) {
            if([[_responseObject objectForKey:[strClassname capitalizedString]] firstObject]){
                
                 [Global SaveAuthKeywithEmail:[[[_responseObject valueForKey:[strClassname capitalizedString]] firstObject] valueForKey:@"email"] ApiKey:[[[_responseObject valueForKey:[strClassname capitalizedString]] firstObject] valueForKey:@"api_plain_key"]];
                
                completion([[_responseObject objectForKey:[strClassname capitalizedString]] firstObject]);
            }else{
                completion(nil);
            }
        }
    }];
}

#pragma mark - Register User

-(void)registerUserWithData:(NSDictionary *)dicData withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void (^)(NSDictionary *responsedic))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicData ClassURL:[NSString stringWithFormat:@"%@/add.json",strClassname] withLoading:isLoading showToastOnSuccess:isShowToast WitCompilation:^(id _responseObject) {
        if (completion) {
                if([[_responseObject objectForKey:[strClassname capitalizedString]] firstObject]){
                    [Global SaveAuthKeywithEmail:[[[_responseObject valueForKey:[strClassname capitalizedString]] firstObject] valueForKey:@"email"] ApiKey:[[[_responseObject valueForKey:[strClassname capitalizedString]] firstObject] valueForKey:@"api_plain_key"]];
                    
                    completion([[_responseObject objectForKey:[strClassname capitalizedString]] firstObject]);
                }else{
                    completion(nil);
                }
        }
    }];
}

#pragma mark - Register Device

-(void)registerDeviceInfoWithDeviceToken:(NSString *)token withCompletion:(void(^)(NSDictionary *responseDic))completion {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *vers = [[UIDevice currentDevice]systemVersion];
    
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *deviceUDID = myDevice.identifierForVendor.UUIDString;
//    NSString *deviceName = myDevice.name;
    NSString *deviceModel = myDevice.model;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    [param setValue:deviceModel forKey:PM_PHONE_NAME];
//    [param setValue:[NSString stringWithFormat:@"%@(%@)",device,vers] forKey:PM_MODEL];
//    [param setValue:token forKey:PM_TOKEN_ID];
//    [param setValue:deviceUDID forKey:PM_UUID];
//    [param setValue:@"ios" forKey:PM_DEVICE_TYPE];
//    [param setValue:[userDefaults valueForKey:PM_ID] forKey:PM_USER_ID];
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:param ClassURL:[NSString stringWithFormat:@"%@/add.json",strClassname] withLoading:NO showToastOnSuccess:NO WitCompilation:^(id _responseObject) {
        if (completion) {
            NSDictionary *di = [_responseObject objectForKey:[strClassname capitalizedString]];
            completion(di);
        }
    }];
}

#pragma mark- Get SYNC Code

-(void)getSyncCode:(NSDictionary *)dicData withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void(^)(NSDictionary *responseDic))completion{
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicData ClassURL:[NSString stringWithFormat:@"%@/synccode.json",strClassname] withLoading:isLoading showToastOnSuccess:isShowToast
                                        WitCompilation:^(id _responseObject) {
        if (completion) {
            NSDictionary *di = [_responseObject objectForKey:[strClassname capitalizedString]];
            completion(di);
        }
    }];
}
#pragma mark - Uploading Image

-(void)uploadFileData:(NSData *)data ForField:(NSString *)strFieldName withfileExtention:(NSString *)strfileExtention withLoading:(BOOL)isShow withCompletion:(void (^)(NSString *fileName))completion
{
    [[WebServicesClass sharedWebServiceClass] JsonCallWithFileData:data withfieldName:strFieldName withfileExtention:strfileExtention ClassURL:[NSString stringWithFormat:@"%@/uploadImage.json",strClassname] withLoading:isShow WitCompilation:^(NSMutableDictionary *Dictionary) {
        if (completion) {
            NSString *file = [[Dictionary objectForKey:strClassname.lowercaseString] valueForKey:strFieldName];
            if (file) {
                completion(file);
            }else{
                completion(nil);
            }

        }
    }];
}

#pragma mark - delete object

-(void)deleteObject:(NSDictionary*)dicData withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void(^)(NSDictionary*dicResponse))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicData ClassURL:[NSString stringWithFormat:@"%@/delete.json",strClassname] withLoading:isLoading showToastOnSuccess:isShowToast WitCompilation:^(id _responseObject) {
        if (completion) {
            completion(_responseObject);
        }
    }];
}

#pragma mark - Insert Object 

-(void)insertObject:(NSDictionary *)dicData withLoading:(BOOL)loading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void (^)(NSDictionary *responsedic))completion
{
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicData ClassURL:[NSString stringWithFormat:@"%@/add.json",strClassname] withLoading:loading showToastOnSuccess:isShowToast WitCompilation:^(id _responseObject) {
        if (completion) {
            completion([_responseObject objectForKey:[strClassname capitalizedString]]);
        }
    }];
}

#pragma mark - update user profile 
-(void)updateUserProfileInformationWithValues:(NSDictionary *)dicValues withCompletion:(void (^)(NSDictionary *response))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicValues ClassURL:[NSString stringWithFormat:@"%@/edit.json",strClassname] withLoading:YES showToastOnSuccess:YES WitCompilation:^(id _responseObject) {
        if (completion) {
            completion([_responseObject objectForKey:[strClassname capitalizedString]]);
        }
    }];
}
#pragma mark - Edit Record
-(void)editRecordWithValues:(NSDictionary *)dicValues withCompletion:(void (^)(NSDictionary *response))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicValues ClassURL:[NSString stringWithFormat:@"%@/edit.json",strClassname] withLoading:YES showToastOnSuccess:YES WitCompilation:^(id _responseObject) {
        if (completion) {
            completion([_responseObject objectForKey:[strClassname capitalizedString]]);
        }
    }];
}

#pragma mark - Update Object
-(void)SetUpdatedFieldsAndValues:(NSDictionary *)dicFields {
    dicUpdate = [dicFields mutableCopy];
}
-(void)updateObjectFields:(NSDictionary *)dicfields withCompletion:(void(^)(BOOL isUpdate))completion {
    NSMutableDictionary *dicAPI = [NSMutableDictionary dictionary];
    if ([dicMain objectForKey:parameterCondition]) {
        [dicAPI setObject:[dicMain objectForKey:parameterCondition] forKey:parameterCondition];
    }
    [dicAPI setObject:dicfields forKey:parameterFields];
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicAPI ClassURL:[NSString stringWithFormat:@"%@/saveAll.json",strClassname] withLoading:YES showToastOnSuccess:YES WitCompilation:^(id _responseObject) {
        if (completion) {
            completion(_responseObject);
        }
    }];
}


-(void)getRecordsQuerywithCompletionWithLoader:(BOOL)isShowLoader showToastOnSuccess:(BOOL)isShowToast WitCompilation:(void (^)(id response))completion {
    
    [[WebServicesClass sharedWebServiceClass] JsonCall:dicMain ClassURL:[NSString stringWithFormat:@"%@.json",strClassname] withLoading:isShowLoader showToastOnSuccess:isShowToast WitCompilation:^(id _responseObject) {
        if (completion) {
            completion([_responseObject objectForKey:[strClassname capitalizedString]]);
        }
    }];
}

@end
