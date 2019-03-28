//
//  DocumentReports.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 26/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Documentreports.h"

@implementation Documentreports

+(void)addReportOnInappropriateDocumentWithData:(NSMutableDictionary*)params WithCompletion:(void (^)(id responsedict))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Documentreports class]];

//    [Global showProgressHUD];
    [model insertObject:params withLoading:YES showToastOnSuccess:YES withCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion(responsedic);
        }
//        [Global dismissProgressHUD];
    }];
}
@end
