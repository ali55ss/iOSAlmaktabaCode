//
//  Colleges.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 16/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Colleges.h"

@implementation Colleges

+(void)getCollegesListOfUniversityID:(int)uni_id WithCompletion:(void (^)(id responsedict))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Colleges class]];
    [model WhereKey:_param_isDeleted Equalto:@"0"];
    [model WhereKey:_param_status Equalto:@"1"];

//    [model WhereKey:@"Colleges.isDeleted" Equalto:@"0"];
    [model WhereKey:_param_university_id Equalto:[NSString stringWithFormat:@"%d",uni_id]];
    [model getRecordsQuerywithCompletionWithLoader:YES showToastOnSuccess:NO WitCompilation:^(id response) {
        if (completion) {
            completion(response);
        }
    }];
}

@end
