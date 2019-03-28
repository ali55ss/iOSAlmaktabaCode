//
//  Userdepartments.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 27/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Userdepartments.h"

@implementation Userdepartments

+(void)enrollUserDepartmentWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    
//    [Global showProgressHUD];
    QueryModel *model = [[QueryModel alloc] initWithClass:[Userdepartments class]];
    [model insertObject:params withLoading:YES showToastOnSuccess:YES withCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion(responsedic);
        }
//        [Global dismissProgressHUD];
    }];
    
}
+(void)editEnrollUserDepartmentWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    
//    [Global showProgressHUD];
    QueryModel *model = [[QueryModel alloc] initWithClass:[Userdepartments class]];
    
    [model editRecordWithValues:params withCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion(responsedic);
        }
//        [Global dismissProgressHUD];

    }];
    
}
@end
