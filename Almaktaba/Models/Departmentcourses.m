//
//  Departmentcourses.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 19/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Departmentcourses.h"

@implementation Departmentcourses
+(void)getCourseListOfDeptID:(int)department_id WithCompletion:(void (^)(id responsedict))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Departmentcourses class]];
    [model WhereKey:_param_isDeleted Equalto:@"0"];
    [model WhereKey:@"Departmentcourses.status" Equalto:@"1"];

//    [model WhereKey:@"courses.isDeleted" Equalto:@"0"];

    [model WhereKey:_param_collegedepartment_id Equalto:[NSString stringWithFormat:@"%d",department_id]];
    [model ContainsObject:@"courses"];
    
    [model getRecordsQuerywithCompletionWithLoader:YES showToastOnSuccess:NO WitCompilation:^(id response) {
        if (completion) {
            completion(response);
        }
    }];
}

@end
