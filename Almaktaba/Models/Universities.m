//
//  Universities.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Universities.h"
#import "Users.h"
@implementation Universities

+(void)getUniversitiesListWithCompletion:(void (^)(id responsedict))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Universities class]];
    [model WhereKey:_param_isDeleted Equalto:@"0"];
    [model WhereKey:_param_status Equalto:@"1"];

    [model getRecordsQuerywithCompletionWithLoader:YES showToastOnSuccess:NO WitCompilation:^(id response) {
        if (completion) {
            completion(response);
        }
    }];
}
+(void)uploadImageWithData:(NSData*)imageData withCompletion:(void (^)(NSString *_fileName))completion{
    
//    [Global showProgressHUD];
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model uploadFileData:imageData ForField:_param_university_image withfileExtention:@"jpg" withLoading:YES withCompletion:^(NSString *fileName) {
        if (completion) {
            completion(fileName);
        }
//        [Global dismissProgressHUD];
    }];
}
@end
