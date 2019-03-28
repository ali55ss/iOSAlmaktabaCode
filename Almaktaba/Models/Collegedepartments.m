//
//  Departments.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 17/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Collegedepartments.h"

@implementation Collegedepartments

+(void)getDepartmentsListOfCollegeID:(int)college_id WithCompletion:(void (^)(id responsedict))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Collegedepartments class]];

    [model WhereKey:_param_college_id Equalto:[NSString stringWithFormat:@"%d",college_id]];
    [model WhereKey:@"Collegedepartments.isDeleted" Equalto:@"0"];

    [model ContainsObject:@"departments"];
    [model SetFields:@"Departments.department_name"];
    [model SetFields:@"Departments.id"];
    [model SetFields:@"Collegedepartments.id"];

//
    //{"conditions":{"college_id":"1"},"fields":["Departments.department_name","Departments.id"],"contain":["departments"],"get":"all" }
    
    [model getRecordsQuerywithCompletionWithLoader:YES showToastOnSuccess:NO WitCompilation:^(id response) {
        if (completion) {
            completion(response);
        }
    }];
}



@end
