//
//  Users.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Users.h"

@implementation Users


+(void)registerUserWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model registerUserWithData:params withLoading:YES showToastOnSuccess:YES withCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion(responsedic);
        }
    }];
}

+(void)loginUserWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
//    [Global showProgressHUD];

    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model loginwithCredentials:params WithCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion(responsedic);
        }
//             [Global dismissProgressHUD];
    }];
}
+(void)forgotPasswordWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model forgotPasswordWithData:params withCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion(responsedic);
        }
   
    }];
}
+(void)uploadImageWithData:(NSData*)imageData withCompletion:(void (^)(NSString *_fileName))completion{
    
//    [Global showProgressHUD];
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model uploadFileData:imageData ForField:_param_profile_image withfileExtention:@"jpg" withLoading:YES withCompletion:^(NSString *fileName) {
        if (completion) {
            completion(fileName);
        }
//        [Global dismissProgressHUD];
    }];
}
+(void)updateUserDetailsWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model updateUserProfileInformationWithValues:params withCompletion:^(NSDictionary *response) {
        if (completion) {
            completion(response);
        }
    }];
}
+(void)getUserDetailsWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model WhereKey:_param_id Equalto:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id]];

    [model getRecordsQuerywithCompletionWithLoader:YES showToastOnSuccess:NO WitCompilation:^(id response) {
        if (completion) {
            completion(response);
        }
    }];
}

@end
