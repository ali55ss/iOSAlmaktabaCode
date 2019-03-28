//
//  Documents.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 20/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Documents.h"
@implementation Documents

+(void)uploadDocumentWithData:(NSData*)docData withMime_type:(NSString*)mime_type withCompletion:(void (^)(NSString *_fileName))completion{
    
//    [Global showProgressHUD];
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model uploadFileData:docData ForField:_param_documents withfileExtention:mime_type withLoading:YES withCompletion:^(NSString *fileName) {
        if (completion) {
            completion(fileName);
        }
//        [Global dismissProgressHUD];
    }];
}
+(void)uploadDocumentFrontPageWithData:(NSData*)docData withMime_type:(NSString*)mime_type withCompletion:(void (^)(NSString *_fileName))completion{
    
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model uploadFileData:docData ForField:_param_documents withfileExtention:mime_type withLoading:YES withCompletion:^(NSString *fileName) {
        if (completion) {
            completion(fileName);
        }
    }];
}

+(void)getDocumentsListOfdepartmentcourse:(int)departmentcourse_id WithCompletion:(void (^)(id responsedict))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Documents class]];
    [model WhereKey:_param_departmentcourse_id Equalto:[NSString stringWithFormat:@"%d",departmentcourse_id]];
    [model WhereKey:@"Documents.isDeleted" Equalto:@"0"];
    [model ContainsObject:@"users"];
    [model SortinDescendingwithfiled:@"Documents.id"];

    [model getRecordsQuerywithCompletionWithLoader:YES showToastOnSuccess:NO WitCompilation:^(id response) {
        if (completion) {
            completion(response);
        }
    }];
}

+(void)saveDocumentDetailsWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Documents class]];
    [model insertObject:params withLoading:YES showToastOnSuccess:YES withCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion(responsedic);
        }
    }];
}
+(void)deleteDocumentWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
//    [Global showProgressHUD];

    QueryModel *model = [[QueryModel alloc] initWithClass:[Documents class]];
    [model deleteObject:params withLoading:YES showToastOnSuccess:YES withCompletion:^(NSDictionary *dicResponse) {
        if (completion) {
            completion(dicResponse);
        }
//         [Global dismissProgressHUD];
    }];
}

@end
