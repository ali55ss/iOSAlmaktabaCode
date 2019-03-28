//
//  Departments.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 17/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Departments.h"
@interface Collegedepartments : NSObject

@property (assign) int id;
@property (assign) int college_id;
@property (strong, nonatomic) NSString *department_name;
@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;

@property (strong, nonatomic) Departments *Departments;

+(void)getDepartmentsListOfCollegeID:(int)college_id WithCompletion:(void (^)(id responsedict))completion;

@end
